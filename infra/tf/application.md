## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.28.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ./modules/ecs | n/a |
| <a name="module_lb"></a> [lb](#module\_lb) | ./modules/lb | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [random_shuffle.random_az](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.ecr_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | the port which http traffic will be configured on the container | `number` | `3000` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | 1-6 char prefix for all resource names | `string` | `"lj-app"` | no |
| <a name="input_route53_domain_base"></a> [route53\_domain\_base](#input\_route53\_domain\_base) | route 53 domain name registered on the aws account | `string` | `"weatherapp.click"` | no |
| <a name="input_route53_domain_name"></a> [route53\_domain\_name](#input\_route53\_domain\_name) | the domain/subdomain to generate an ssl cert for | `string` | `"lj-app.weatherapp.click"` | no |
| <a name="input_ssm_resource_prefix"></a> [ssm\_resource\_prefix](#input\_ssm\_resource\_prefix) | first path structure section for ssm resources | `string` | `"lj-pathways-dojo"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | additional tags for aws resources | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_dns_record"></a> [aws\_dns\_record](#output\_aws\_dns\_record) | the domain name which the desployed application should be accessible via |
| <a name="output_aws_lb_target_group_arn"></a> [aws\_lb\_target\_group\_arn](#output\_aws\_lb\_target\_group\_arn) | load balancer target group |
| <a name="output_aws_lb_url"></a> [aws\_lb\_url](#output\_aws\_lb\_url) | direct dns access to the load balancer |