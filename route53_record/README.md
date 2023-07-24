# route53-record Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domain | Domain zone name | string | n/a | yes |
| instance\_count | Instance Count | string | n/a | yes |
| name | Resource record name | list | n/a | yes |
| private\_zone | Set true for private zone | string | `"false"` | no |
| records | String with records, separated by comma | list | n/a | yes |
| ttl | The TTL of the record | string | `"30"` | no |
| type | The record type | string | `"A"` | no |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | Fully qualified domain name |