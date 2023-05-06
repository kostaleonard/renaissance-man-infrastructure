# CI/CD notes

To set up authentication to GCP in your CI/CD, use Google's [auth Action](https://github.com/marketplace/actions/authenticate-to-google-cloud).
Follow the instructions in the guide to create the Service Account, Workload
Identity Pool, OIDC, and IAM policy binding.
The instructions also reference the [gh-oidc Terraform module](https://github.com/terraform-google-modules/terraform-google-github-actions-runners/tree/master/modules/gh-oidc),
which will create the aforementioned resources automatically.
However, CI/CD workflows won't be able to create the authentication resources if
they do not exist (since the CI/CD job cannot authenticate).
We chose to execute the steps in the instructions manually without using the
Terraform module.
