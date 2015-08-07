# How SepDuplicateToken works

## DuplicateToken so important

If we want to get a workable token to use when CreateProcessAsUser,
we have to use DuplicateToken, and we can provide several important parameters,
for example, the Impersonation Level and Token Type.

The IL is so important as James Shaw says, I am going to see what has happened 
in the process of DuplicateToken.

## RtlSidHashInitialize

very exciting name, maybe we can find some hints about the algorithm of hashing.

## SepDuplicateToken routine from WRK

parameter validation

             429     if ( TokenType == TokenImpersonation ) {
             430 
             431         ASSERT( SecurityDelegation     > SecurityImpersonation );
             432         ASSERT( SecurityImpersonation  > SecurityIdentification );
             433         ASSERT( SecurityIdentification > SecurityAnonymous );
             434 
             435         if ( (ImpersonationLevel > SecurityDelegation)  ||
             436              (ImpersonationLevel < SecurityAnonymous) ) {
             437 
             438             return STATUS_BAD_IMPERSONATION_LEVEL;
             439         }
             440     }

after some proxy and audit data processing, it directly create a new Token object:

             502     Status = ObCreateObject(
             503                  RequestorMode,      // ProbeMode
             504                  SeTokenObjectType, // ObjectType
             505                  ObjectAttributes,   // ObjectAttributes
             506                  RequestorMode,      // OwnershipMode
             507                  NULL,               // ParseContext
             508                  TokenBodyLength,    // ObjectBodySize
             509                  PagedPoolSize,      // PagedPoolCharge
             510                  NonPagedPoolSize,   // NonPagedPoolCharge
             511                  (PVOID *)&NewToken  // Return pointer to object
             512                  );


then just copy some simple fields from existing token or respective parameters to
the new token:

             529     ExAllocateLocallyUniqueId( &(NewToken->TokenId) );
             530     NewToken->TokenInUse = FALSE;
             531     NewToken->TokenType = TokenType;
             532     NewToken->ImpersonationLevel = ImpersonationLevel;
             533     NewToken->TokenLock = TokenLock;
             534 
             535     ExInitializeResourceLite( NewToken->TokenLock );
             536 
             537     NewToken->AuthenticationId = ExistingToken->AuthenticationId;
             538     NewToken->TokenSource = ExistingToken->TokenSource;
             539     NewToken->DynamicAvailable = 0;
             540     NewToken->ProxyData = NewProxyData;
             541     NewToken->AuditData = NewAuditData;
             542     NewToken->ParentTokenId = ExistingToken->ParentTokenId;
             543     NewToken->ExpirationTime = ExistingToken->ExpirationTime;
             544     NewToken->OriginatingLogonSession  = ExistingToken->OriginatingLogonSession ;

same as above:

             562     NewToken->ModifiedId = ExistingToken->ModifiedId;
             563     NewToken->DynamicCharged = ExistingToken->DynamicCharged;
             564     NewToken->DefaultOwnerIndex = ExistingToken->DefaultOwnerIndex;
             565     NewToken->UserAndGroupCount = ExistingToken->UserAndGroupCount;
             566     NewToken->RestrictedSidCount = ExistingToken->RestrictedSidCount;
             567     NewToken->PrivilegeCount = ExistingToken->PrivilegeCount;
             568     NewToken->VariableLength = ExistingToken->VariableLength;
             569     NewToken->TokenFlags = ExistingToken->TokenFlags & ~TOKEN_SESSION_NOT_REFERENCED;
             570     NewToken->SessionId = ExistingToken->SessionId;
             571     NewToken->AuditPolicy = ExistingToken->AuditPolicy;

duplicate logon session reference:

             580     Status = SepDuplicateLogonSessionReference (NewToken, ExistingToken);

Then for some varariant part of the token, reuse the existing allocated buffer, just adjust the pointers to them.

It seems WRK has not gave us sufficient information for this duplicate process.

## How NtDuplicateToken works

after inspecting SepDuplicateToken codes,
we believe some important logic are controled by NtDuplicateToken,
which is before SepDuplicateToken.

first capture the options specified in the object attribute parameter:

             165     Status = SeCaptureSecurityQos(                                                                                                                        
             166                  ObjectAttributes,                                                                                                                        
             167                  PreviousMode,
             168                  &SecurityQosPresent,                                                                                                                     
             169                  &SecurityQos                                                                                                                             
             170                  );                                                                                                                                       
             171     
             172     if (!NT_SUCCESS(Status)) {                                                                                                                            
             173         return Status;                                                                                                                                    
             174     }  

then get the pointer to the existig token object:


             183     Status = ObReferenceObjectByHandle(  
             184                  ExistingTokenHandle,    // Handle
             185                  TOKEN_DUPLICATE,        // DesiredAccess
             186                  SeTokenObjectType,     // ObjectType
             187                  PreviousMode,           // AccessMode
             188                  (PVOID *)&Token,        // Object
             189                  &HandleInformation      // GrantedAccess
             190                  );

as we can see, the Impersonation Level options for the new token are passing 
through the object attribute parameter.

If no explicit Impersonation Level given, just copy from the existing token.

             219     if ( !SecurityQosPresent ) {
             220 
             221         SecurityQos.ImpersonationLevel = Token->ImpersonationLevel;
             222 
             223     }


If we want to get an impersonation token by duplicating an existing impersionation token,

            Impersonation Token --> Impersonation Token

the requested impersonation level could not be higher than the existing token's impersonation level.

             232     if ( (Token->TokenType == TokenImpersonation) &&
             233          (TokenType == TokenImpersonation)
             234        ) {
             235 
             236         //
             237         // Make sure a legitimate transformation is being requested:
             238         //
             239         //    (1) The impersonation level of a target duplicate must not
             240         //        exceed that of the source token.
             241         //
             242         //
             243 
             244         ASSERT( SecurityDelegation     > SecurityImpersonation );
             245         ASSERT( SecurityImpersonation  > SecurityIdentification );
             246         ASSERT( SecurityIdentification > SecurityAnonymous );
             247 
             248         if ( (SecurityQos.ImpersonationLevel > Token->ImpersonationLevel) ) {
             249 
             250             ObDereferenceObject( (PVOID)Token );
             251             if (SecurityQosPresent) {
             252                 SeFreeCapturedSecurityQos( &SecurityQos );
             253             }
             254             return STATUS_BAD_IMPERSONATION_LEVEL;
             255         }
             256 
             257     }

If we want to producing a primary token from an existing impersonation token, 

            Impersonation Token --> Primary Token

the existing impersonation token's impersonation level should not be lower than *Impersonation* Level.

             265     if ( (Token->TokenType == TokenImpersonation) &&
             266          (TokenType == TokenPrimary)              &&
             267          (Token->ImpersonationLevel <  SecurityImpersonation)
             268        ) {
             269         ObDereferenceObject( (PVOID)Token );
             270         if (SecurityQosPresent) {
             271             SeFreeCapturedSecurityQos( &SecurityQos );
             272         }
             273         return STATUS_BAD_IMPERSONATION_LEVEL;
             274     }

then NtDuplicateToken will call SepDuplicateToken.

## Recap

###  Primary Token --> Impersonation Token
###  Primary Token --> Primary Token

do just as parameters says

### Impersonation Token --> Primary Token

if the existing impersonation token has a level lower than *Impersonation*, for example, 
the *Identification*, it means this token cannot produce any other Primary Token.

This is forbidden.

### Impersonation Token --> Impersonation Token

the requested level should not be higher than the existing token's level.

It means the impersonation level should not be elevated during the duplication process.
























