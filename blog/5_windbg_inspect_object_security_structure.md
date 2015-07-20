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

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`0167e000
           +0x008 QuotaProcess     : 0xfffffa80`1a742b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000200 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`016e0500 - 0xfffff8a0`0162b580 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x358
           +0x050 LastFreeHandleEntry : 0xfffff8a0`0167eff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0xd5
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0xd7

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01748001
           +0x008 QuotaProcess     : 0xfffffa80`1acf0060 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`0000025c Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`016de970 - 0xfffff8a0`0167d990 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x4d0
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01749ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x16a
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x16d

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`0170c000
           +0x008 QuotaProcess     : 0xfffffa80`1a6ffb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000298 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0174dae0 - 0xfffff8a0`016e0500 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0xc
           +0x050 LastFreeHandleEntry : 0xfffff8a0`0170cff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x38
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x3a

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`02226001
           +0x008 QuotaProcess     : 0xfffffa80`1ad1c060 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000002c4 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`017cba20 - 0xfffff8a0`016de970 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0xcc
           +0x050 LastFreeHandleEntry : 0xfffff8a0`0217cff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x110
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x115

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01920001
           +0x008 QuotaProcess     : 0xfffffa80`1ad898e0 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000340 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01861ef0 - 0xfffff8a0`0174dae0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x620
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01921ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x185
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x187

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01c83001
           +0x008 QuotaProcess     : 0xfffffa80`1ada4640 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000370 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0185d160 - 0xfffff8a0`017cba20 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x660
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01c84ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x197
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x1bc

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01949001
           +0x008 QuotaProcess     : 0xfffffa80`1adab1b0 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000388 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`017ac360 - 0xfffff8a0`01861ef0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x588
           +0x050 LastFreeHandleEntry : 0xfffff8a0`021c1ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x33f
           +0x05c NextHandleNeedingPool : 0x1000
           +0x060 HandleCountHighWatermark : 0x37d

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01888000
           +0x008 QuotaProcess     : 0xfffffa80`1add8060 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000003d0 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`018bba40 - 0xfffff8a0`0185d160 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x1cc
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01888ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x7c
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x90

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01f6c001
           +0x008 QuotaProcess     : 0xfffffa80`1adfeb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000108 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0184e2f0 - 0xfffff8a0`017ac360 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x8ac
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02027ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x228
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x22a

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01c93001
           +0x008 QuotaProcess     : 0xfffffa80`1ae22b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000002b4 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`019827d0 - 0xfffff8a0`018bba40 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x804
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01ff6ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x205
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x207

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01da2001
           +0x008 QuotaProcess     : 0xfffffa80`1ae9a550 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000460 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0199aa20 - 0xfffff8a0`0184e2f0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x234
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01ce7ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x14f
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x158

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01e39001
           +0x008 QuotaProcess     : 0xfffffa80`1aeb7b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000488 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01bacdd0 - 0xfffff8a0`019827d0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x540
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01e3aff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x14f
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x153

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01bae000
           +0x008 QuotaProcess     : 0xfffffa80`1af50b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000550 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01c0cd30 - 0xfffff8a0`0199aa20 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x254
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01baeff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x9f
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0xa5

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01c1f000
           +0x008 QuotaProcess     : 0xfffffa80`1af9eb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000594 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01c165c0 - 0xfffff8a0`01bacdd0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x140
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01c1fff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x67
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x6a

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01e1d001
           +0x008 QuotaProcess     : 0xfffffa80`1afafb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000005a0 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01bd4b90 - 0xfffff8a0`01c0cd30 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0xab8
           +0x050 LastFreeHandleEntry : 0xfffff8a0`020eaff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x29c
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x2b3

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`02461001
           +0x008 QuotaProcess     : 0xfffffa80`1afedb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000005d4 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01fdc5c0 - 0xfffff8a0`01c165c0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x450
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02462ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x112
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x114

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01df4000
           +0x008 QuotaProcess     : 0xfffffa80`1b144b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000007c0 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01deb980 - 0xfffff8a0`01bd4b90 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x23c
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01df4ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x8d
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x8f

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01e8f000
           +0x008 QuotaProcess     : 0xfffffa80`1b131480 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`0000049c Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01e14030 - 0xfffff8a0`01fdc5c0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x2f8
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01e8fff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0xc3
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0xc8

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01e52000
           +0x008 QuotaProcess     : 0xfffffa80`1b16bb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000544 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01ce29f0 - 0xfffff8a0`01deb980 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x37c
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01e52ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0xde
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0xe1

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01f65000
           +0x008 QuotaProcess     : 0xfffffa80`1b1e5b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000002b0 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01c7a910 - 0xfffff8a0`01e14030 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x150
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01f65ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x7a
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x89

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01f75000
           +0x008 QuotaProcess     : 0xfffffa80`1b1e44e0 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000007c8 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01fe76a0 - 0xfffff8a0`01ce29f0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x8c
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01f75ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x22
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x23

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01fee000
           +0x008 QuotaProcess     : 0xfffffa80`1b2229e0 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000678 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01d11be0 - 0xfffff8a0`01c7a910 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x30c
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01feeff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0xd0
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0xd4

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`0207c000
           +0x008 QuotaProcess     : 0xfffffa80`1a745b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000850 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`021deae0 - 0xfffff8a0`01fe76a0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x198
           +0x050 LastFreeHandleEntry : 0xfffff8a0`0207cff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x9b
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x9e

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`021f8000
           +0x008 QuotaProcess     : 0xfffffa80`1a7b5060 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000910 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`021ebe00 - 0xfffff8a0`01d11be0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x16c
           +0x050 LastFreeHandleEntry : 0xfffff8a0`021f8ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x79
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x7c

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`021b8001
           +0x008 QuotaProcess     : 0xfffffa80`1a7e4b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000944 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0233fd30 - 0xfffff8a0`021deae0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x9b8
           +0x050 LastFreeHandleEntry : 0xfffff8a0`022f8ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x270
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x274

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`02344000
           +0x008 QuotaProcess     : 0xfffffa80`19123b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000009d0 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`02352890 - 0xfffff8a0`021ebe00 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x21c
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02344ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x89
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x8e

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`023da001
           +0x008 QuotaProcess     : 0xfffffa80`19209b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000009f0 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`02052980 - 0xfffff8a0`0233fd30 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x3b4
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02391ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x114
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x11a

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`02371001
           +0x008 QuotaProcess     : 0xfffffa80`1921bb30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000a04 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff800`02c73850 - 0xfffff8a0`02352890 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x114
           +0x050 LastFreeHandleEntry : 0xfffff8a0`02373ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x51
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x53

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0
           +0x008 QuotaProcess     : (null) 
           +0x010 UniqueProcessId  : (null) 
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`000017a0 - 0xfffff8a0`02052980 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n565152
           +0x044 Flags            : 0xfffff8a0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x88a20
           +0x050 LastFreeHandleEntry : (null) 
           +0x058 HandleCount      : 0
           +0x05c NextHandleNeedingPool : 0
           +0x060 HandleCountHighWatermark : 0

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`017bb001
           +0x008 QuotaProcess     : (null) 
           +0x010 UniqueProcessId  : 0x00000000`00000004 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`005c1770 - 0xfffff800`02c73850 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x5c8
           +0x050 LastFreeHandleEntry : 0xfffff8a0`020f6ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x1e5
           +0x05c NextHandleNeedingPool : 0xc00
           +0x060 HandleCountHighWatermark : 0x20a

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`005c5000
           +0x008 QuotaProcess     : 0xfffffa80`194d7820 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`000000fc Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`014d8770 - 0xfffff8a0`000017a0 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x78
           +0x050 LastFreeHandleEntry : 0xfffff8a0`005c5ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x1d
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x1e

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01bb3001
           +0x008 QuotaProcess     : 0xfffffa80`1a184b30 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000148 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01559790 - 0xfffff8a0`005c1770 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x750
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01bb4ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x1ed
           +0x05c NextHandleNeedingPool : 0x800
           +0x060 HandleCountHighWatermark : 0x1f7

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01562000
           +0x008 QuotaProcess     : 0xfffffa80`1a723950 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`0000017c Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`01575d40 - 0xfffff8a0`014d8770 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x174
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01562ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0xcd
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0xd2

        dt _HANDLE_TABLE @$extret-0x20 
        nt!_HANDLE_TABLE
           +0x000 TableCode        : 0xfffff8a0`01576000
           +0x008 QuotaProcess     : 0xfffffa80`1a728890 _EPROCESS
           +0x010 UniqueProcessId  : 0x00000000`00000184 Void
           +0x018 HandleLock       : _EX_PUSH_LOCK
           +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`014eaf80 - 0xfffff8a0`01559790 ]
           +0x030 HandleContentionEvent : _EX_PUSH_LOCK
           +0x038 DebugInfo        : (null) 
           +0x040 ExtraInfoPages   : 0n0
           +0x044 Flags            : 0
           +0x044 StrictFIFO       : 0y0
           +0x048 FirstFreeHandle  : 0x168
           +0x050 LastFreeHandleEntry : 0xfffff8a0`01576ff0 _HANDLE_TABLE_ENTRY
           +0x058 HandleCount      : 0x59
           +0x05c NextHandleNeedingPool : 0x400
           +0x060 HandleCountHighWatermark : 0x5b

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

