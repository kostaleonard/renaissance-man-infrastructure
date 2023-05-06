# IAM and security notes

## On project IDs

Some GCP users claim that project IDs are sensitive information, but these
claims do not appear to be accurate.
GCP uses project IDs to uniquely identify groups of resources.
[GCP's documentation](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
states the following regarding the project ID.

> Don't include sensitive information in your project name, project ID, or other resource names. The project ID is used in the name of many other Google Cloud resources, and any reference to the project or related resources exposes the project ID and resource name.

This verbiage suggests that the project ID itself is not sensitive information.
Even knowing the project ID, an attacker cannot perform any actions on project
resources unless they also have the IAM permissions to do so.
Based on how frequently the project ID appears in resource names and other
outputs, it seems rational to conclude that the project ID is publicly known.
