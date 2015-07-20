# Windbg Inspect Object & Security related data structures

## how to dump a process's handle table

        kd> !process 0 0 lsass.exe
        PROCESS fffffa801ac9b140
            SessionId: 0  Cid: 01f8    Peb: 7fffffdb000  ParentCid: 0184
            DirBase: 2159a000  ObjectTable: fffff8a00162b560  HandleCount: 510.
            Image: lsass.exe

        kd> dt _HANDLE_TABLE fffff8a00162b560
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`016cf001
           +0x008 QuotaProcess     : 0xfffffa80`1ac9b140 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000001f8 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0167d990 - 0xfffff8a0`0165fbe0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x7a4
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02377ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x1fe
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x206

we can confirm this structure with pid(0x1f8).

        kd> !list "-t _LIST_ENTRY.Flink -e -x \"dt _HANDLE_TABLE @$extret-0x20\" fffff8a00162b560+0x20"
        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`016cf001
           +0x008 QuotaProcess     : 0xfffffa80`1ac9b140 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000001f8 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0167d990 - 0xfffff8a0`0165fbe0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x7a4
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02377ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x1fe
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x206

	......

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01569000
           +0x008 QuotaProcess     : 0xfffffa80`1a72fb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000001a8 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0165fbe0 - 0xfffff8a0`01575d40 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0xe4
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01569ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x75
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x79

But the result is quite odd, it's every processes' \_HANDLE\_TABLE member, 
we can confirm this with the pid and handle count against the result of *!process 0 0*.

Apparently this is not the handle table, but where is it?

It is in the "TableCode" member, and the lower 2 bits indicates the table level.

        kd> dq fffff8a00162b560
        fffff8a0`0162b560  fffff8a0`016cf001 fffffa80`1ac9b140

So the table is 2 levels (the lower 2 bits: 01 means 2 levels, 00 means 1 level),
and the address of the first level table is fffff8a0016cf001 & 0xFFFFFFFFFFFFFF00 = fffff8a0016cf000

        kd> dq fffff8a0`016cf000
        fffff8a0`016cf000  fffff8a0`0167a000 fffff8a0`016d0000
        fffff8a0`016cf010  fffff8a0`02377000 00000000`00000000
        fffff8a0`016cf020  00000000`00000000 00000000`00000000

we can see 3 entries:

so the first 256 handles are in the first table at fffff8a00167a000, each entry occupy a 8 byte pointer to \_OBJECT\_HEADER, 
and an access mask of 4 bytes, but for alignment, it occupies total 16 bytes.

so each table is 16 * 256 = 0x10 * 0x100 = 4096 = 0x1000 bytes, it is just ONE page.

we check the 0004 handle, it should be within the first 2-level table

        kd> dq fffff8a0`0167a000
        fffff8a0`0167a000  00000000`00000000 00000000`fffffffe
        fffff8a0`0167a010  fffff8a0`01675691 00000000`00000009
        fffff8a0`0167a020  fffff8a0`0387ade1 00000000`00000003
        fffff8a0`0167a030  fffffa80`1a73ba01 00000000`00100020
        fffff8a0`0167a040  fffff8a0`01660e51 00000000`00020019
        fffff8a0`0167a050  fffffa80`1ac9dae1 00000000`001f0001
        fffff8a0`0167a060  fffffa80`1a73b601 00000000`001f0001
        fffff8a0`0167a070  fffffa80`1ac9d8b1 00000000`001f0001

so it address is fffff8a001660e50 ( the lower 3 bits are ignored), and access mask is 0000000000020019.

we see the \_OBJECT\_HEADER structure.

        kd> dt _OBJECT_HEADER fffff8a0`01660e50
        nt!_OBJECT_HEADER
           +0x000 PointerCount     : 0n1
           +0x008 HandleCount      : 0n1
           +0x008 NextToFree       : 0x00000000`00000001 Void
           +0x010 Lock             : _EX_PUSH_LOCK
           +0x018 TypeIndex        : 0x23 '#'
           +0x019 TraceFlags       : 0 ''
           +0x01a InfoMask         : 0x8 ''
           +0x01b Flags            : 0 ''
           +0x020 ObjectCreateInfo : 0xfffff800`02c5bc00 _OBJECT_CREATE_INFORMATION
           +0x020 QuotaBlockCharged : 0xfffff800`02c5bc00 Void
           +0x028 SecurityDescriptor : (null) 
           +0x030 Body             : _QUAD
        kd> !object fffff8a0`01660e50+0x30
        Object: fffff8a001660e80  Type: (fffffa8018dfb3c0) Key
            ObjectHeader: fffff8a001660e50 (new version)
            HandleCount: 1  PointerCount: 1
            Directory Object: 00000000  Name: \REGISTRY\MACHINE\SYSTEM\CONTROLSET001\CONTROL\NLS\SORTING\VERSIONS

seems convincing, lets confirm it with !handle command.
but it turns out to be the 0x30 handle, what is the problem?

        kd> !handle 0x10 7 0x1f8

        Searching for Process with Cid == 1f8
        PROCESS fffffa801ac9b140
            SessionId: 0  Cid: 01f8    Peb: 7fffffdb000  ParentCid: 0184
            DirBase: 2159a000  ObjectTable: fffff8a00162b560  HandleCount: 510.
            Image: lsass.exe

        Handle table at fffff8a00162b560 with 510 entries in use

        0010: Object: fffff8a001660e80  GrantedAccess: 00020019 Entry: fffff8a00167a040
        Object: fffff8a001660e80  Type: (fffffa8018dfb3c0) Key
            ObjectHeader: fffff8a001660e50 (new version)
                HandleCount: 1  PointerCount: 1
                Directory Object: 00000000  Name: \REGISTRY\MACHINE\SYSTEM\CONTROLSET001\CONTROL\NLS\SORTING\VERSIONS

so the handle is the offset divided by 4, where 4 is each entry's size. so the examined entry is (fffff8a00167a040 - fffff8a00167a000)/ 4 = 0x10.


