export ENV

COMPOSE_RUN_TERRAFORM = docker-compose -f ./infra/docker-compose.yml -f ./infra/docker-compose.$(ENV).yml run --rm tf
COMPOSE_RUN_BASH = docker-compose -f ./infra/docker-compose.yml -f ./infra/docker-compose.$(ENV).yml run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose -f ./infra/docker-compose.yml -f ./infra/docker-compose.$(ENV).yml run --rm --entrypoint aws tf

# TERRAFORM
.PHONY: run_plan
run_plan: init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: init
init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: plan
plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

.PHONY: apply
apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

# AWS
.PHONY: list_bucket
list_bucket: 
	$(COMPOSE_RUN_AWS) s3 ls
