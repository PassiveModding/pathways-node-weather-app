## Using MAKE

The commands for make allow specifying the environment (infra layer) to apply terraform commands to the specified layer.

```sh
$ make [command]
```
### Commands:
- `version`
- `init ENV=[layer]` - runs `terraform init`, `validate` and `format` on the target layer
- `plan ENV=[layer]` - runs `terraform plan` on the target layer
- `apply ENV=[layer]` - runs `terraform apply` on the target layer
- `destroy_plan ENV=[layer]` - runs `terraform plan -destroy` on the target layer
- `destroy_apply ENV=[layer]` - runs `terraform destroy -auto-approve` on the target layer
- `run_[command] ENV=[layer]` - runs `make init` followed by the specified command
- `list_bucket` - used to test s3 credentials, runs `aws s3 ls` to list buckets

### Layers:
- `reg` - aws ecr for pushing image builds to
- `vpc` - the network layer
- `app` - ecs for container orchestration, balancing and scaling

### Example:
```sh
$ make run_plan ENV=vpc
```