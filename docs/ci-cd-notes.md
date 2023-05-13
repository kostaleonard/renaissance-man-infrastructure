# CI/CD notes

## Authenticating to GCP using a key

The most straightforward way to authenticate to GCP is with a key.
Terraform's [quick start guide for GCP](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
describes this approach.
In the GCP console, create a Service Account and a JSON key for that account.
Then, store the credentials in a GitHub repository secret called
`GOOGLE_CREDENTIALS`.
CI/CD jobs will have access to the secret and will authenticate automatically
because the GCP CLI tool `gcloud` looks for the `GOOGLE_CREDENTIALS` environment
variable.
Instead of setting the environment variable, you could also read the secret into
a Terraform variable and reference it in the `credentials` argument for the
`google` Terraform provider.

If you are using Terraform Cloud, you can store the GCP credentials as a secret
in the Terraform Cloud console, then use a Terraform Cloud API token in your
CI/CD.
Use `cat gcp-credentials.json | jq -c` to format your secret, as
[this guide](https://support.hashicorp.com/hc/en-us/articles/4406586874387-How-to-set-up-Google-Cloud-GCP-credentials-in-Terraform-Cloud) notes.
The advantage of using Terraform Cloud is that you will not get errors when you
run Terraform commands on different workstations or CI/CD runners.
These errors occur because Terraform defaults to tracking state locally (the
state file `terraform.tfstate` contains sensitive information not appropriate
for storage in public version control--see [Terraform docs](https://developer.hashicorp.com/terraform/language/state)).
If you run `terraform apply` on computer A and then attempt `terraform destroy`
on computer B, the latter operation will fail because computer B does not have
an accurate state file.
We use Terraform Cloud in this project for convenience and security.

## Authenticating to GCP using an OIDC provider

To set up authentication to GCP using an OIDC provider, use Google's
[auth Action](https://github.com/marketplace/actions/authenticate-to-google-cloud).
Follow the instructions in the guide to create the Service Account, Workload
Identity Pool, OIDC, and IAM policy binding.
The instructions also reference the [gh-oidc Terraform module](https://github.com/terraform-google-modules/terraform-google-github-actions-runners/tree/master/modules/gh-oidc),
which will create the aforementioned resources automatically.
However, CI/CD workflows won't be able to create the authentication resources
(since the CI/CD job cannot authenticate).
This dependency can cause inconsistencies in CI/CD workflows that run
Terraform.
For example, if one CI/CD job runs `terraform destroy` and removes the OIDC
resources, subsequent CI/CD jobs will fail because there is no way to
authenticate.
Since you only need to create the OIDC resources once, it might make sense
execute the steps in the instructions manually.
You could also manage them in a separate Terraform plan.
Both of these alternatives are a little inconvenient, so we chose to
authenticate with a key, as described above.
