# From EPROCESS to TOKEN

show the basic information of the current test process:

            kd> !process 0 0 framework.exe
            PROCESS fffffa801b81e060
                SessionId: 1  Cid: 042c    Peb: 7fffffdf000  ParentCid: 092c
                DirBase: 195ea000  ObjectTable: fffff8a00abfb810  HandleCount:  41.
                Image: framework.exe

so the EPROCESS struct is located at fffffa801b81e060, 
and I believe the detailed information above are all extracted from this struct.

The below struct definition are extracted from pdb file with SymbolTypeViewer.

                      typedef struct _EPROCESS                                               // 135 elements, 0x4D0 bytes (sizeof) 
                      {                                                                                                            
            /*0x000*/     struct _KPROCESS Pcb;                                              // 37 elements, 0x160 bytes (sizeof)  
            /*0x160*/     struct _EX_PUSH_LOCK ProcessLock;                                  // 7 elements, 0x8 bytes (sizeof)     
            /*0x168*/     union _LARGE_INTEGER CreateTime;                                   // 4 elements, 0x8 bytes (sizeof)     
            /*0x170*/     union _LARGE_INTEGER ExitTime;                                     // 4 elements, 0x8 bytes (sizeof)     
            /*0x178*/     struct _EX_RUNDOWN_REF RundownProtect;                             // 2 elements, 0x8 bytes (sizeof)     
            /*0x180*/     VOID*        UniqueProcessId;                                                                            
            /*0x188*/     struct _LIST_ENTRY ActiveProcessLinks;                             // 2 elements, 0x10 bytes (sizeof)    
            /*0x198*/     UINT64       ProcessQuotaUsage[2];                                                                       
            /*0x1A8*/     UINT64       ProcessQuotaPeak[2];                                                                        
            /*0x1B8*/     UINT64       CommitCharge;                                                                               
            /*0x1C0*/     struct _EPROCESS_QUOTA_BLOCK* QuotaBlock;                                                                
            /*0x1C8*/     struct _PS_CPU_QUOTA_BLOCK* CpuQuotaBlock;                                                               
            /*0x1D0*/     UINT64       PeakVirtualSize;                                                                            
            /*0x1D8*/     UINT64       VirtualSize;                                                                                
            /*0x1E0*/     struct _LIST_ENTRY SessionProcessLinks;                            // 2 elements, 0x10 bytes (sizeof)    
            /*0x1F0*/     VOID*        DebugPort;                                                                                  
                          union                                                              // 3 elements, 0x8 bytes (sizeof)     
                          {                                                                                                        
            /*0x1F8*/         VOID*        ExceptionPortData;                                                                      
            /*0x1F8*/         UINT64       ExceptionPortValue;                                                                     
            /*0x1F8*/         UINT64       ExceptionPortState : 3;                           // 0 BitPosition                      
                          };                                                                                                       
            /*0x200*/     struct _HANDLE_TABLE* ObjectTable;                                                                       
            /*0x208*/     struct _EX_FAST_REF Token;                                         // 3 elements, 0x8 bytes (sizeof)     
            /*0x210*/     UINT64       WorkingSetPage;                                                                             
            /*0x218*/     struct _EX_PUSH_LOCK AddressCreationLock;                          // 7 elements, 0x8 bytes (sizeof)     
            /*0x220*/     struct _ETHREAD* RotateInProgress;                                                                       
            /*0x228*/     struct _ETHREAD* ForkInProgress;                                                                         
            /*0x230*/     UINT64       HardwareTrigger;                                                                            
            /*0x238*/     struct _MM_AVL_TABLE* PhysicalVadRoot;                                                                   
            /*0x240*/     VOID*        CloneRoot;                                                                                  
            /*0x248*/     UINT64       NumberOfPrivatePages;                                                                       
            /*0x250*/     UINT64       NumberOfLockedPages;                                                                        
            /*0x258*/     VOID*        Win32Process;                                                                               
            /*0x260*/     struct _EJOB* Job;                                                                                       
            /*0x268*/     VOID*        SectionObject;                                                                              
            /*0x270*/     VOID*        SectionBaseAddress;                                                                         
            /*0x278*/     ULONG32      Cookie;                                                                                     
            /*0x27C*/     ULONG32      UmsScheduledThreads;                                                                        
            /*0x280*/     struct _PAGEFAULT_HISTORY* WorkingSetWatch;                                                              
            /*0x288*/     VOID*        Win32WindowStation;                                                                         
            /*0x290*/     VOID*        InheritedFromUniqueProcessId;                                                               
            /*0x298*/     VOID*        LdtInformation;                                                                             
            /*0x2A0*/     VOID*        Spare;                                                                                      
            /*0x2A8*/     UINT64       ConsoleHostProcess;                                                                         
            /*0x2B0*/     VOID*        DeviceMap;                                                                                  
            /*0x2B8*/     VOID*        EtwDataSource;                                                                              
            /*0x2C0*/     VOID*        FreeTebHint;                                                                                
            /*0x2C8*/     VOID*        FreeUmsTebHint;                                                                             
                          union                                                              // 2 elements, 0x8 bytes (sizeof)     
                          {                                                                                                        
            /*0x2D0*/         struct _HARDWARE_PTE PageDirectoryPte;                         // 16 elements, 0x8 bytes (sizeof)    
            /*0x2D0*/         UINT64       Filler;                                                                                 
                          };                                                                                                       
            /*0x2D8*/     VOID*        Session;                                                                                    
            /*0x2E0*/     UINT8        ImageFileName[15];                                                                          
            /*0x2EF*/     UINT8        PriorityClass;                                                                              
            /*0x2F0*/     struct _LIST_ENTRY JobLinks;                                       // 2 elements, 0x10 bytes (sizeof)    
            /*0x300*/     VOID*        LockedPagesList;                                                                            
            /*0x308*/     struct _LIST_ENTRY ThreadListHead;                                 // 2 elements, 0x10 bytes (sizeof)    
            /*0x318*/     VOID*        SecurityPort;                                                                               
            /*0x320*/     VOID*        Wow64Process;                                                                               
            /*0x328*/     ULONG32      ActiveThreads;                                                                              
            /*0x32C*/     ULONG32      ImagePathHash;                                                                              
            /*0x330*/     ULONG32      DefaultHardErrorProcessing;                                                                 
            /*0x334*/     LONG32       LastThreadExitStatus;                                                                       
            /*0x338*/     struct _PEB* Peb;                                                                                        
            /*0x340*/     struct _EX_FAST_REF PrefetchTrace;                                 // 3 elements, 0x8 bytes (sizeof)     
            /*0x348*/     union _LARGE_INTEGER ReadOperationCount;                           // 4 elements, 0x8 bytes (sizeof)     
            /*0x350*/     union _LARGE_INTEGER WriteOperationCount;                          // 4 elements, 0x8 bytes (sizeof)     
            /*0x358*/     union _LARGE_INTEGER OtherOperationCount;                          // 4 elements, 0x8 bytes (sizeof)     
            /*0x360*/     union _LARGE_INTEGER ReadTransferCount;                            // 4 elements, 0x8 bytes (sizeof)     
            /*0x368*/     union _LARGE_INTEGER WriteTransferCount;                           // 4 elements, 0x8 bytes (sizeof)     
            /*0x370*/     union _LARGE_INTEGER OtherTransferCount;                           // 4 elements, 0x8 bytes (sizeof)     
            /*0x378*/     UINT64       CommitChargeLimit;                                                                          
            /*0x380*/     UINT64       CommitChargePeak;                                                                           
            /*0x388*/     VOID*        AweInfo;                                                                                    
            /*0x390*/     struct _SE_AUDIT_PROCESS_CREATION_INFO SeAuditProcessCreationInfo; // 1 elements, 0x8 bytes (sizeof)     
            /*0x398*/     struct _MMSUPPORT Vm;                                              // 21 elements, 0x88 bytes (sizeof)   
            /*0x420*/     struct _LIST_ENTRY MmProcessLinks;                                 // 2 elements, 0x10 bytes (sizeof)    
            /*0x430*/     VOID*        HighestUserAddress;                                                                         
            /*0x438*/     ULONG32      ModifiedPageCount;                                                                          
                          union                                                              // 2 elements, 0x4 bytes (sizeof)     
                          {                                                                                                        
            /*0x43C*/         ULONG32      Flags2;                                                                                 
                              struct                                                         // 20 elements, 0x4 bytes (sizeof)    
                              {                                                                                                    
            /*0x43C*/             ULONG32      JobNotReallyActive : 1;                       // 0 BitPosition                      
            /*0x43C*/             ULONG32      AccountingFolded : 1;                         // 1 BitPosition                      
            /*0x43C*/             ULONG32      NewProcessReported : 1;                       // 2 BitPosition                      
            /*0x43C*/             ULONG32      ExitProcessReported : 1;                      // 3 BitPosition                      
            /*0x43C*/             ULONG32      ReportCommitChanges : 1;                      // 4 BitPosition                      
            /*0x43C*/             ULONG32      LastReportMemory : 1;                         // 5 BitPosition                      
            /*0x43C*/             ULONG32      ReportPhysicalPageChanges : 1;                // 6 BitPosition                      
            /*0x43C*/             ULONG32      HandleTableRundown : 1;                       // 7 BitPosition                      
            /*0x43C*/             ULONG32      NeedsHandleRundown : 1;                       // 8 BitPosition                      
            /*0x43C*/             ULONG32      RefTraceEnabled : 1;                          // 9 BitPosition                      
            /*0x43C*/             ULONG32      NumaAware : 1;                                // 10 BitPosition                     
            /*0x43C*/             ULONG32      ProtectedProcess : 1;                         // 11 BitPosition                     
            /*0x43C*/             ULONG32      DefaultPagePriority : 3;                      // 12 BitPosition                     
            /*0x43C*/             ULONG32      PrimaryTokenFrozen : 1;                       // 15 BitPosition                     
            /*0x43C*/             ULONG32      ProcessVerifierTarget : 1;                    // 16 BitPosition                     
            /*0x43C*/             ULONG32      StackRandomizationDisabled : 1;               // 17 BitPosition                     
            /*0x43C*/             ULONG32      AffinityPermanent : 1;                        // 18 BitPosition                     
            /*0x43C*/             ULONG32      AffinityUpdateEnable : 1;                     // 19 BitPosition                     
            /*0x43C*/             ULONG32      PropagateNode : 1;                            // 20 BitPosition                     
            /*0x43C*/             ULONG32      ExplicitAffinity : 1;                         // 21 BitPosition                     
                              };                                                                                                   
                          };                                                                                                       
                          union                                                              // 2 elements, 0x4 bytes (sizeof)     
                          {                                                                                                        
            /*0x440*/         ULONG32      Flags;                                                                                  
                              struct                                                         // 29 elements, 0x4 bytes (sizeof)    
                              {                                                                                                    
            /*0x440*/             ULONG32      CreateReported : 1;                           // 0 BitPosition                      
            /*0x440*/             ULONG32      NoDebugInherit : 1;                           // 1 BitPosition                      
            /*0x440*/             ULONG32      ProcessExiting : 1;                           // 2 BitPosition                      
            /*0x440*/             ULONG32      ProcessDelete : 1;                            // 3 BitPosition                      
            /*0x440*/             ULONG32      Wow64SplitPages : 1;                          // 4 BitPosition                      
            /*0x440*/             ULONG32      VmDeleted : 1;                                // 5 BitPosition                      
            /*0x440*/             ULONG32      OutswapEnabled : 1;                           // 6 BitPosition                      
            /*0x440*/             ULONG32      Outswapped : 1;                               // 7 BitPosition                      
            /*0x440*/             ULONG32      ForkFailed : 1;                               // 8 BitPosition                      
            /*0x440*/             ULONG32      Wow64VaSpace4Gb : 1;                          // 9 BitPosition                      
            /*0x440*/             ULONG32      AddressSpaceInitialized : 2;                  // 10 BitPosition                     
            /*0x440*/             ULONG32      SetTimerResolution : 1;                       // 12 BitPosition                     
            /*0x440*/             ULONG32      BreakOnTermination : 1;                       // 13 BitPosition                     
            /*0x440*/             ULONG32      DeprioritizeViews : 1;                        // 14 BitPosition                     
            /*0x440*/             ULONG32      WriteWatch : 1;                               // 15 BitPosition                     
            /*0x440*/             ULONG32      ProcessInSession : 1;                         // 16 BitPosition                     
            /*0x440*/             ULONG32      OverrideAddressSpace : 1;                     // 17 BitPosition                     
            /*0x440*/             ULONG32      HasAddressSpace : 1;                          // 18 BitPosition                     
            /*0x440*/             ULONG32      LaunchPrefetched : 1;                         // 19 BitPosition                     
            /*0x440*/             ULONG32      InjectInpageErrors : 1;                       // 20 BitPosition                     
            /*0x440*/             ULONG32      VmTopDown : 1;                                // 21 BitPosition                     
            /*0x440*/             ULONG32      ImageNotifyDone : 1;                          // 22 BitPosition                     
            /*0x440*/             ULONG32      PdeUpdateNeeded : 1;                          // 23 BitPosition                     
            /*0x440*/             ULONG32      VdmAllowed : 1;                               // 24 BitPosition                     
            /*0x440*/             ULONG32      CrossSessionCreate : 1;                       // 25 BitPosition                     
            /*0x440*/             ULONG32      ProcessInserted : 1;                          // 26 BitPosition                     
            /*0x440*/             ULONG32      DefaultIoPriority : 3;                        // 27 BitPosition                     
            /*0x440*/             ULONG32      ProcessSelfDelete : 1;                        // 30 BitPosition                     
            /*0x440*/             ULONG32      SetTimerResolutionLink : 1;                   // 31 BitPosition                     
                              };                                                                                                   
                          };                                                                                                       
            /*0x444*/     LONG32       ExitStatus;                                                                                 
            /*0x448*/     struct _MM_AVL_TABLE VadRoot;                                      // 6 elements, 0x40 bytes (sizeof)    
            /*0x488*/     struct _ALPC_PROCESS_CONTEXT AlpcContext;                          // 3 elements, 0x20 bytes (sizeof)    
            /*0x4A8*/     struct _LIST_ENTRY TimerResolutionLink;                            // 2 elements, 0x10 bytes (sizeof)    
            /*0x4B8*/     ULONG32      RequestedTimerResolution;                                                                   
            /*0x4BC*/     ULONG32      ActiveThreadsHighWatermark;                                                                 
            /*0x4C0*/     ULONG32      SmallestTimerResolution;                                                                    
            /*0x4C4*/     UINT8        _PADDING0_[0x4];                                                                            
            /*0x4C8*/     struct _PO_DIAG_STACK_RECORD* TimerResolutionStackRecord;                                                
                      }EPROCESS, *PEPROCESS;     

And the run-time windbg output is :

            kd> dt _EPROCESS fffffa801b81e060
            ntdll!_EPROCESS
               +0x000 Pcb              : _KPROCESS
               +0x160 ProcessLock      : _EX_PUSH_LOCK
               +0x168 CreateTime       : _LARGE_INTEGER 0x01d0c5b3`2e1f8b49
               +0x170 ExitTime         : _LARGE_INTEGER 0x0
               +0x178 RundownProtect   : _EX_RUNDOWN_REF
               +0x180 UniqueProcessId  : 0x00000000`0000042c Void
               +0x188 ActiveProcessLinks : _LIST_ENTRY [ 0xfffffa80`1bafbcb8 - 0xfffffa80`198a1468 ]
               +0x198 ProcessQuotaUsage : [2] 0xda0
               +0x1a8 ProcessQuotaPeak : [2] 0xda0
               +0x1b8 CommitCharge     : 0xd4
               +0x1c0 QuotaBlock       : 0xfffffa80`1ad2c400 _EPROCESS_QUOTA_BLOCK
               +0x1c8 CpuQuotaBlock    : (null) 
               +0x1d0 PeakVirtualSize  : 0xc77000
               +0x1d8 VirtualSize      : 0xc77000
               +0x1e0 SessionProcessLinks : _LIST_ENTRY [ 0xfffffa80`1bafbd10 - 0xfffffa80`1ac85d10 ]
               +0x1f0 DebugPort        : (null) 
               +0x1f8 ExceptionPortData : 0xfffffa80`1ac37090 Void
               +0x1f8 ExceptionPortValue : 0xfffffa80`1ac37090
               +0x1f8 ExceptionPortState : 0y000
               +0x200 ObjectTable      : 0xfffff8a0`0abfb810 _HANDLE_TABLE
               +0x208 Token            : _EX_FAST_REF
               +0x210 WorkingSetPage   : 0x70dee
               +0x218 AddressCreationLock : _EX_PUSH_LOCK
               +0x220 RotateInProgress : (null) 
               +0x228 ForkInProgress   : (null) 
               +0x230 HardwareTrigger  : 0
               +0x238 PhysicalVadRoot  : (null) 
               +0x240 CloneRoot        : (null) 
               +0x248 NumberOfPrivatePages : 0xb7
               +0x250 NumberOfLockedPages : 0
               +0x258 Win32Process     : 0xfffff900`c2917ce0 Void
               +0x260 Job              : (null) 
               +0x268 SectionObject    : 0xfffff8a0`02f05950 Void
               +0x270 SectionBaseAddress : 0x00000001`3f970000 Void
               +0x278 Cookie           : 0xf725c3d8
               +0x27c Spare8           : 0
               +0x280 WorkingSetWatch  : (null) 
               +0x288 Win32WindowStation : (null) 
               +0x290 InheritedFromUniqueProcessId : 0x00000000`0000092c Void
               +0x298 LdtInformation   : (null) 
               +0x2a0 Spare            : (null) 
               +0x2a8 ConsoleHostProcess : 0xae4
               +0x2b0 DeviceMap        : 0xfffff8a0`0155def0 Void
               +0x2b8 EtwDataSource    : (null) 
               +0x2c0 FreeTebHint      : 0x000007ff`fffdb000 Void
               +0x2c8 PageDirectoryPte : _HARDWARE_PTE
               +0x2c8 Filler           : 0x00000001`00000000
               +0x2d0 Session          : (null) 
               +0x2d8 ImageFileName    : [15]  ""
               +0x2e7 PriorityClass    : 0x72 'r'
               +0x2e8 JobLinks         : _LIST_ENTRY [ 0x02000065`78652e6b - 0x00000000`00000000 ]
               +0x2f8 LockedPagesList  : (null) 
               +0x300 ThreadListHead   : _LIST_ENTRY [ 0x00000000`00000000 - 0xfffffa80`1bb6abc0 ]
               +0x310 SecurityPort     : 0xfffffa80`1bb91f80 Void
               +0x318 Wow64Process     : (null) 
               +0x320 ActiveThreads    : 0
               +0x324 ImagePathHash    : 0
               +0x328 DefaultHardErrorProcessing : 2
               +0x32c LastThreadExitStatus : 0n335488289
               +0x330 Peb              : 0x00000000`00000001 _PEB
               +0x338 PrefetchTrace    : _EX_FAST_REF
               +0x340 ReadOperationCount : _LARGE_INTEGER 0x0
               +0x348 WriteOperationCount : _LARGE_INTEGER 0x0
               +0x350 OtherOperationCount : _LARGE_INTEGER 0x0
               +0x358 ReadTransferCount : _LARGE_INTEGER 0x0
               +0x360 WriteTransferCount : _LARGE_INTEGER 0x0
               +0x368 OtherTransferCount : _LARGE_INTEGER 0x0
               +0x370 CommitChargeLimit : 0
               +0x378 CommitChargePeak : 0
               +0x380 AweInfo          : 0x00000000`000000d4 Void
               +0x388 SeAuditProcessCreationInfo : _SE_AUDIT_PROCESS_CREATION_INFO
               +0x390 Vm               : _MMSUPPORT
               +0x418 MmProcessLinks   : _LIST_ENTRY [ 0x00020000`00000000 - 0xfffffa80`1bafbf50 ]
               +0x428 HighestUserAddress : 0xfffffa80`198a1700 Void
               +0x430 ModifiedPageCount : 0xffff0000
               +0x434 Flags2           : 0x7ff
               +0x434 JobNotReallyActive : 0y1
               +0x434 AccountingFolded : 0y1
               +0x434 NewProcessReported : 0y1
               +0x434 ExitProcessReported : 0y1
               +0x434 ReportCommitChanges : 0y1
               +0x434 LastReportMemory : 0y1
               +0x434 ReportPhysicalPageChanges : 0y1
               +0x434 HandleTableRundown : 0y1
               +0x434 NeedsHandleRundown : 0y1
               +0x434 RefTraceEnabled  : 0y1
               +0x434 NumaAware        : 0y1
               +0x434 ProtectedProcess : 0y0
               +0x434 DefaultPagePriority : 0y000
               +0x434 PrimaryTokenFrozen : 0y0
               +0x434 ProcessVerifierTarget : 0y0
               +0x434 StackRandomizationDisabled : 0y0
               +0x434 AffinityPermanent : 0y0
               +0x434 AffinityUpdateEnable : 0y0
               +0x434 PropagateNode    : 0y0
               +0x434 ExplicitAffinity : 0y0
               +0x438 Flags            : 2
               +0x438 CreateReported   : 0y0
               +0x438 NoDebugInherit   : 0y1
               +0x438 ProcessExiting   : 0y0
               +0x438 ProcessDelete    : 0y0
               +0x438 Wow64SplitPages  : 0y0
               +0x438 VmDeleted        : 0y0
               +0x438 OutswapEnabled   : 0y0
               +0x438 Outswapped       : 0y0
               +0x438 ForkFailed       : 0y0
               +0x438 Wow64VaSpace4Gb  : 0y0
               +0x438 AddressSpaceInitialized : 0y00
               +0x438 SetTimerResolution : 0y0
               +0x438 BreakOnTermination : 0y0
               +0x438 DeprioritizeViews : 0y0
               +0x438 WriteWatch       : 0y0
               +0x438 ProcessInSession : 0y0
               +0x438 OverrideAddressSpace : 0y0
               +0x438 HasAddressSpace  : 0y0
               +0x438 LaunchPrefetched : 0y0
               +0x438 InjectInpageErrors : 0y0
               +0x438 VmTopDown        : 0y0
               +0x438 ImageNotifyDone  : 0y0
               +0x438 PdeUpdateNeeded  : 0y0
               +0x438 VdmAllowed       : 0y0
               +0x438 CrossSessionCreate : 0y0
               +0x438 ProcessInserted  : 0y0
               +0x438 DefaultIoPriority : 0y000
               +0x438 ProcessSelfDelete : 0y0
               +0x438 SetTimerResolutionLink : 0y0
               +0x43c ExitStatus       : 0n53248
               +0x440 VadRoot          : _MM_AVL_TABLE
               +0x480 AlpcContext      : _ALPC_PROCESS_CONTEXT
               +0x4a0 TimerResolutionLink : _LIST_ENTRY [ 0x00000000`00000000 - 0x00000000`00000000 ]
               +0x4b0 RequestedTimerResolution : 0
               +0x4b4 ActiveThreadsHighWatermark : 0
               +0x4b8 SmallestTimerResolution : 0
               +0x4c0 TimerResolutionStackRecord : (null) 

Now we have breaked at NtSetInformationToken, the parameters are :

                kd> r rcx, rdx, r8, r9
                rcx=00000000000000a4 rdx=0000000000000004 r8=0000000000404410 r9=0000000000000014

The prototype is:

                BOOL WINAPI SetTokenInformation(
                  _In_ HANDLE                  TokenHandle,                 [0xa4]
                  _In_ TOKEN_INFORMATION_CLASS TokenInformationClass,       [0x04 = TokenOwner]
                  _In_ LPVOID                  TokenInformation,            [0x404410]
                  _In_ DWORD                   TokenInformationLength       [0x14]
                );

Let's replay the process to get the token object correspond to handle 0xa4.
first get the handle table:

                kd> dt _HANDLE_TABLE 0xfffff8a0`0abfb810
                ntdll!_HANDLE_TABLE
                   +0x000 TableCode        : 0xfffff8a0`08a80000
                   +0x008 QuotaProcess     : 0xfffffa80`1b81e060 _EPROCESS
                   +0x010 UniqueProcessId  : 0x00000000`0000042c Void
                   +0x018 HandleLock       : _EX_PUSH_LOCK
                   +0x020 HandleTableList  : _LIST_ENTRY [ 0xfffff8a0`0ab77be0 - 0xfffff8a0`0abf1260 ]
                   +0x030 HandleContentionEvent : _EX_PUSH_LOCK
                   +0x038 DebugInfo        : (null) 
                   +0x040 ExtraInfoPages   : 0n0
                   +0x044 Flags            : 0
                   +0x044 StrictFIFO       : 0y0
                   +0x048 FirstFreeHandle  : 0xa8
                   +0x050 LastFreeHandleEntry : 0xfffff8a0`08a80ff0 _HANDLE_TABLE_ENTRY
                   +0x058 HandleCount      : 0x29
                   +0x05c NextHandleNeedingPool : 0x400
                   +0x060 HandleCountHighWatermark : 0x29

the handle table is located in (TableCode & 0xFFFFFFFFFFFFFF00), 
and the (TableCode & 0xFF) indicates the table level of the handle table, here 0 represents only 1 level.

So the 0xa4 entry is located at (TableCode & 0xFFFFFFFFFFFFFF00) + 0xa4 * 4:

                kd> dq (0xfffff8a0`08a80000 & 0xFFFFFFFFFFFFFF00) + 0xa4 * 4 L2
                fffff8a0`08a80290  fffff8a0`023a0033 00000000`000f01ff

The first qword & 0xFFFFFFFFFFFFFFF8 is the address of the object header, the second qword is the access mask.

                kd> dt _OBJECT_HEADER (fffff8a0`023a0033 & 0xFFFFFFFFFFFFFFF8)
                nt!_OBJECT_HEADER
                   +0x000 PointerCount     : 0n12
                   +0x008 HandleCount      : 0n3
                   +0x008 NextToFree       : 0x00000000`00000003 Void
                   +0x010 Lock             : _EX_PUSH_LOCK
                   +0x018 TypeIndex        : 0x5 ''
                   +0x019 TraceFlags       : 0 ''
                   +0x01a InfoMask         : 0x8 ''
                   +0x01b Flags            : 0x2 ''
                   +0x020 ObjectCreateInfo : 0xfffff800`02c06c00 _OBJECT_CREATE_INFORMATION
                   +0x020 QuotaBlockCharged : 0xfffff800`02c06c00 Void
                   +0x028 SecurityDescriptor : 0xfffff8a0`01b39c47 Void
                   +0x030 Body             : _QUAD

after the object header is the object body, for token object, it is just the TOKEN struct.

                kd> dt _TOKEN ((fffff8a0`023a0033 & 0xFFFFFFFFFFFFFFF8) + 0x30)
                nt!_TOKEN
                   +0x000 TokenSource      : _TOKEN_SOURCE
                   +0x010 TokenId          : _LUID
                   +0x018 AuthenticationId : _LUID
                   +0x020 ParentTokenId    : _LUID
                   +0x028 ExpirationTime   : _LARGE_INTEGER 0x7fffffff`ffffffff
                   +0x030 TokenLock        : 0xfffffa80`1ae15c70 _ERESOURCE
                   +0x038 ModifiedId       : _LUID
                   +0x040 Privileges       : _SEP_TOKEN_PRIVILEGES
                   +0x058 AuditPolicy      : _SEP_AUDIT_POLICY
                   +0x074 SessionId        : 1
                   +0x078 UserAndGroupCount : 0xd
                   +0x07c RestrictedSidCount : 0
                   +0x080 VariableLength   : 0x264
                   +0x084 DynamicCharged   : 0x400
                   +0x088 DynamicAvailable : 0
                   +0x08c DefaultOwnerIndex : 3
                   +0x090 UserAndGroups    : 0xfffff8a0`023a0368 _SID_AND_ATTRIBUTES
                   +0x098 RestrictedSids   : (null) 
                   +0x0a0 PrimaryGroup     : 0xfffff8a0`0abe9f90 Void
                   +0x0a8 DynamicPart      : 0xfffff8a0`0abe9f90  -> 0x501
                   +0x0b0 DefaultDacl      : 0xfffff8a0`0abe9fac _ACL
                   +0x0b8 TokenType        : 1 ( TokenPrimary )
                   +0x0bc ImpersonationLevel : 0 ( SecurityAnonymous )
                   +0x0c0 TokenFlags       : 0x2000
                   +0x0c4 TokenInUse       : 0x1 ''
                   +0x0c8 IntegrityLevelIndex : 0xc
                   +0x0cc MandatoryPolicy  : 1
                   +0x0d0 LogonSession     : 0xfffff8a0`013a3460 _SEP_LOGON_SESSION_REFERENCES
                   +0x0d8 OriginatingLogonSession : _LUID
                   +0x0e0 SidHash          : _SID_AND_ATTRIBUTES_HASH
                   +0x1f0 RestrictedSidHash : _SID_AND_ATTRIBUTES_HASH
                   +0x300 pSecurityAttributes : 0xfffff8a0`0ab77b80 _AUTHZBASEP_SECURITY_ATTRIBUTES_INFORMATION
                   +0x308 VariablePart     : 0xfffff8a0`023a0438

also see the struct definition from SymbolTypeViewer:

                          typedef struct _TOKEN                                                        // 33 elements, 0x310 bytes (sizeof) 
                          {                                                                                                                 
                /*0x000*/     struct _TOKEN_SOURCE TokenSource;                                        // 2 elements, 0x10 bytes (sizeof)   
                /*0x010*/     struct _LUID TokenId;                                                    // 2 elements, 0x8 bytes (sizeof)    
                /*0x018*/     struct _LUID AuthenticationId;                                           // 2 elements, 0x8 bytes (sizeof)    
                /*0x020*/     struct _LUID ParentTokenId;                                              // 2 elements, 0x8 bytes (sizeof)    
                /*0x028*/     union _LARGE_INTEGER ExpirationTime;                                     // 4 elements, 0x8 bytes (sizeof)    
                /*0x030*/     struct _ERESOURCE* TokenLock;                                                                                 
                /*0x038*/     struct _LUID ModifiedId;                                                 // 2 elements, 0x8 bytes (sizeof)    
                /*0x040*/     struct _SEP_TOKEN_PRIVILEGES Privileges;                                 // 3 elements, 0x18 bytes (sizeof)   
                /*0x058*/     struct _SEP_AUDIT_POLICY AuditPolicy;                                    // 2 elements, 0x1C bytes (sizeof)   
                /*0x074*/     ULONG32      SessionId;                                                                                       
                /*0x078*/     ULONG32      UserAndGroupCount;                                                                               
                /*0x07C*/     ULONG32      RestrictedSidCount;                                                                              
                /*0x080*/     ULONG32      VariableLength;                                                                                  
                /*0x084*/     ULONG32      DynamicCharged;                                                                                  
                /*0x088*/     ULONG32      DynamicAvailable;                                                                                
                /*0x08C*/     ULONG32      DefaultOwnerIndex;                                                                               
                /*0x090*/     struct _SID_AND_ATTRIBUTES* UserAndGroups;                                                                    
                /*0x098*/     struct _SID_AND_ATTRIBUTES* RestrictedSids;                                                                   
                /*0x0A0*/     VOID*        PrimaryGroup;                                                                                    
                /*0x0A8*/     ULONG32*     DynamicPart;                                                                                     
                /*0x0B0*/     struct _ACL* DefaultDacl;                                                                                     
                /*0x0B8*/     enum _TOKEN_TYPE TokenType;                                                                                   
                /*0x0BC*/     enum _SECURITY_IMPERSONATION_LEVEL ImpersonationLevel;                                                        
                /*0x0C0*/     ULONG32      TokenFlags;                                                                                      
                /*0x0C4*/     UINT8        TokenInUse;                                                                                      
                /*0x0C5*/     UINT8        _PADDING0_[0x3];                                                                                 
                /*0x0C8*/     ULONG32      IntegrityLevelIndex;                                                                             
                /*0x0CC*/     ULONG32      MandatoryPolicy;                                                                                 
                /*0x0D0*/     struct _SEP_LOGON_SESSION_REFERENCES* LogonSession;                                                           
                /*0x0D8*/     struct _LUID OriginatingLogonSession;                                    // 2 elements, 0x8 bytes (sizeof)    
                /*0x0E0*/     struct _SID_AND_ATTRIBUTES_HASH SidHash;                                 // 3 elements, 0x110 bytes (sizeof)  
                /*0x1F0*/     struct _SID_AND_ATTRIBUTES_HASH RestrictedSidHash;                       // 3 elements, 0x110 bytes (sizeof)  
                /*0x300*/     struct _AUTHZBASEP_SECURITY_ATTRIBUTES_INFORMATION* pSecurityAttributes;                                      
                /*0x308*/     UINT64       VariablePart;                                                                                    
                          }TOKEN, *PTOKEN;                                                                                                  
                                 


