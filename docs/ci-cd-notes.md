# CI/CD notes

TODO clean up

TODO Guide [here](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).

TODO set project ID or fill with your project ID

```bash
gcloud iam workload-identity-pools create "renaissance-man-pool" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="Renaissance Man Pool"
```

```bash
gcloud iam workload-identity-pools providers create-oidc "renaissance-man-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="renaissance-man-pool" \
  --display-name="Renaissance Man Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

```bash
gcloud iam workload-identity-pools describe "renaissance-man-pool" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --format="value(name)"
export WORKLOAD_IDENTITY_POOL_ID="projects/502036974399/locations/global/workloadIdentityPools/renaissance-man-pool" # from above
```

```bash
gcloud iam service-accounts add-iam-policy-binding "terraform@renaissance-man-385715.iam.gserviceaccount.com" \
  --project="renaissance-man-385715" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/502036974399/locations/global/workloadIdentityPools/renaissance-man-pool/attribute.repository/kostaleonard/renaissance-man-infrastructure"
```

```bash
gcloud iam workload-identity-pools providers describe "renaissance-man-provider" \
  --project="renaissance-man-385715" \
  --location="global" \
  --workload-identity-pool="renaissance-man-pool" \
  --format="value(name)"
```
