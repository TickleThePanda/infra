The first time we run terraform within auth, it must be from an account with:
 - `roles/iam.workloadIdentityPoolAdmin`
 - `roles/iam.roleAdmin`
 - `roles/iam.serviceAccountAdmin`

From then on, it should be able to manage itself.
