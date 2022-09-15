## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ssm_parameter.ecr_repository_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | name of the repo to be created | `string` | `"lj-weather-app"` | no |
| <a name="input_ssm_resource_prefix"></a> [ssm\_resource\_prefix](#input\_ssm\_resource\_prefix) | first path structure section for ssm resources | `string` | `"lj-pathways-dojo"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | additional tags for the repository resource | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | the url which can be used to push/pull images from |
