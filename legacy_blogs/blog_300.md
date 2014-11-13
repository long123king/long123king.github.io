<https://github.com/rajkosto/deps-detours/tree/master/samples/syelog>

学习IO完成端口，最好的例子是Detours中的模块syelog，它为了高效地接收多个来源的log，创建了IO完成端口以及线程池，线程池中的线程数目为当前processor数目的8倍。

    BOOL CreateWorkers(HANDLE hCompletionPort)
    {
        DWORD dwThread;
        HANDLE hThread;
        DWORD i;
        SYSTEM_INFO SystemInfo;
    
        GetSystemInfo(&SystemInfo);
    
        for (i = 0; i < 2 * SystemInfo.dwNumberOfProcessors; i++) {
            hThread = CreateThread(NULL, 0, WorkerThread, hCompletionPort, 0, &dwThread);
            if (!hThread) {
                MyErrExit("CreateThread WorkerThread");
                // Unreachable: return FALSE;
            }
            CloseHandle(hThread);
        }
        return TRUE;
    }
　　

然后创建pipe文件，并且将pipe文件与IO完成端口绑定到一起，当其他线程（进程）向该pipe文件写数据时，会通过异步方式写，

    VOID SyelogExV(BOOL fTerminate, BYTE nSeverity, PCSTR pszMsgf, va_list args)
    {
        SYELOG_MESSAGE Message;
        DWORD cbWritten = 0;
    
        Real_GetSystemTimeAsFileTime(&Message.ftOccurance);
        Message.fTerminate = fTerminate;
        Message.nFacility = s_nFacility;
        Message.nSeverity = nSeverity;
        Message.nProcessId = s_nProcessId;
        PCHAR pszBuf = Message.szMessage;
        PCHAR pszEnd = Message.szMessage + ARRAYSIZE(Message.szMessage) - 1;
        if (s_szIdent[0]) {
            pszBuf = do_str(pszBuf, pszEnd, s_szIdent);
        }
        *pszEnd = '\0';
        VSafePrintf(pszMsgf, args,
                    pszBuf, (int)(Message.szMessage + sizeof(Message.szMessage) - 1 - pszBuf));
    
        pszEnd = Message.szMessage;
        for (; *pszEnd; pszEnd++) {
            // no internal contents.
        }
    
        // Insure that the message always ends with a '\n'
        //
        if (pszEnd > Message.szMessage) {
            if (pszEnd[-1] != '\n') {
                *pszEnd++ = '\n';
                *pszEnd++ = '\0';
            }
            else {
                *pszEnd++ = '\0';
            }
        }
        else {
            *pszEnd++ = '\n';
            *pszEnd++ = '\0';
        }
        Message.nBytes = (USHORT)(pszEnd - ((PCSTR)&Message));
    
        Real_EnterCriticalSection(&s_csPipe);
    
        if (syelogIsOpen(&Message.ftOccurance)) {
            if (!Real_WriteFile(s_hPipe, &Message, Message.nBytes, &cbWritten, NULL)) {
                s_nPipeError = GetLastError();
                if (s_nPipeError == ERROR_BAD_IMPERSONATION_LEVEL) {
                    // Don't close the file just for a temporary impersonation level.
                }
                else {
                    if (s_hPipe != INVALID_HANDLE_VALUE) {
                        Real_CloseHandle(s_hPipe);
                        s_hPipe = INVALID_HANDLE_VALUE;
                    }
                    if (syelogIsOpen(&Message.ftOccurance)) {
                        Real_WriteFile(s_hPipe, &Message, Message.nBytes, &cbWritten, NULL);
                    }
                }
            }
        }
    
        Real_LeaveCriticalSection(&s_csPipe);
    }
　　

如果写操作完成，会使正在等待的线程池中的一个线程结束对GetQueuedCompletionStatus的等待

    DWORD WINAPI WorkerThread(LPVOID pvVoid)
    {
        PCLIENT pClient;
        BOOL b;
        LPOVERLAPPED lpo;
        DWORD nBytes;
        HANDLE hCompletionPort = (HANDLE)pvVoid;
    
        for (BOOL fKeepLooping = TRUE; fKeepLooping;) {
            pClient = NULL;
            lpo = NULL;
            nBytes = 0;
            b = GetQueuedCompletionStatus(hCompletionPort,
                                          &nBytes, (PULONG_PTR)&pClient, &lpo, INFINITE);
    
            if (!b || lpo == NULL) {
                fKeepLooping = FALSE;
                MyErrExit("GetQueuedCompletionState");
                break;
            }
            else if (!b) {
                if (pClient) {
                    if (GetLastError() == ERROR_BROKEN_PIPE) {
                        LogMessageV(SYELOG_SEVERITY_INFORMATION, "Client closed pipe.");
                    }
                    else {
                        LogMessageV(SYELOG_SEVERITY_ERROR,
                                    "GetQueuedCompletionStatus failed %d [%p]",
                                    GetLastError(), pClient);
                    }
                    CloseConnection(pClient);
                }
                continue;
            }
    
            if (pClient->fAwaitingAccept) {
                InterlockedIncrement(&s_nActiveClients);
                pClient->fAwaitingAccept = FALSE;
                b = ReadFile(pClient->hPipe,
                             &pClient->Message,
                             sizeof(pClient->Message),
                             &nBytes,
                             pClient);
                if (!b) {
                    if (GetLastError() != ERROR_IO_PENDING) {
                        LogMessageV(SYELOG_SEVERITY_ERROR,
                                    "ReadFile failed %d.", GetLastError());
                        continue;
                    }
                }
    
                CreatePipeConnection(hCompletionPort);
            }
            else {
                if (nBytes < offsetof(SYELOG_MESSAGE, szMessage)) {
                    CloseConnection(pClient);
                }
    
                if (pClient->Message.fTerminate) {
                    LogMessageV(SYELOG_SEVERITY_NOTICE,
                                "Client requested terminate on next connection close.");
                    s_fExitAfterOne = TRUE;
                }
    
                LogMessage(&pClient->Message, nBytes);
    
                b = ReadFile(pClient->hPipe,
                             &pClient->Message,
                             sizeof(pClient->Message),
                             &nBytes,
                             pClient);
                if (!b && GetLastError() == ERROR_BROKEN_PIPE) {
                    CloseConnection(pClient);
                }
            }
        }
        return 0;
    }
并且将写的结果通过Overlapped结构体传递给该线程，从而向log文件中添加内容。

 
