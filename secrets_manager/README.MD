# secrets_manager Module
Module to Create and Store Secrets in AWS Secrets Manager

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| secret | Secret to be stored within the secret key | string | n/a | yes |
| secret\_key\_name | Name of the secret key to be created in secrets manager | string | n/a | yes |
| tags | Tags which will be applied to all resources that accept them. Tags will also be used to dynamically generate names and extract information about the environment we're deploying into. | map | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| secret\_key | Secrets Manager id for db master username |
| secret\_key\_name | Secrets Manager name for db master username |