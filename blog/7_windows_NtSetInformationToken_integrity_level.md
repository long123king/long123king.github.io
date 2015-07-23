# What does it mean for integrity level attribute

let's see the codes below:

            loc_1403A9BB4:
            cmp     r12d, 10h
            jb      loc_1403AA374

            lea     rax, [rsp+118h+var_48]
            mov     [rsp+118h+var_D8], rax ; __int64
            lea     rax, [rsp+118h+var_68]
            mov     [rsp+118h+var_E0], rax ; __int64
            mov     dword ptr [rsp+118h+Object], esi ; int
            xor     r9d, r9d        ; int
            mov     r8b, r14b       ; int
            lea     edx, [r9+1]     ; int
            mov     rcx, r15        ; Src
            call    SeCaptureSidAndAttributesArray
            mov     [rsp+118h+var_BC], eax
            jmp     short loc_1403A9C07

It first do the following check:

            if (Length >= sizeof(TOKEN_MANDATORY_LABEL))
                //continue;

then invoke SeCaptureSidAndAttributesArray.

Actually we find no hint about the attribute value until here.

Let's google it, a piece of code come to my eyes:

            PTSTR szIntegritySid = "S-1-16-12288"; //high
            PSID pIntegritySid = NULL;
            TOKEN_MANDATORY_LABEL TIL = {0};

            ConvertStringSidToSid(szIntegritySid, &pIntegritySid);
            TIL.Label.Attributes = SE_GROUP_INTEGRITY;
            TIL.Label.Sid = pIntegritySid;

            AmSetTokenInformation(*hRunToken, TokenIntegrityLevel, &TIL,
            sizeof(TOKEN_MANDATORY_LABEL) + GetLengthSid(pIntegritySid));
            //------------------------------------------------------------------------

So the attribute is just group attributes:

			{ 0x00000020, "integrity" },
			{ 0x00000040, "integrity-enabled" },

So the attribute should be 0x60.

By the way, another piece of code to use the linked elevated token to create a new process with admin rights:

            TOKEN_LINKED_TOKEN linkedToken = {0};
            /* The token is not elevated, we will build an elevated token for the */
            /* user. */
            dwSize = sizeof linkedToken;
            /* Get the linked token, which is the elevated version of the current */
            /* token. */
            if (GetTokenInformation(hToken,
            TokenLinkedToken,
            &linkedToken,
            dwSize, &dwSize)) {
            /* The linked token is not a primary token, so we create one from it. */
            if (DuplicateTokenEx(linkedToken.LinkedToken,
            MAXIMUM_ALLOWED,
            NULL,
            SecurityImpersonation,
            TokenPrimary,
            &hPrimaryToken)) {

and they both come from [here](http://microsoft.public.platformsdk.security.narkive.com/8GZREGtk/how-to-create-an-process-with-administrator-privilege-from-service).

That's all for this.

