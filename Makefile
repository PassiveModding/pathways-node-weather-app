COMPOSE_RUN_BASH = docker-compose -f ./infra/docker-compose.yml -f ./infra/docker-compose.root.yml run --rm --entrypoint bash tf

################################
### TERRAFORM
################################
export ENV
COMPOSE_RUN_TERRAFORM = docker-compose -f ./infra/docker-compose.yml -f ./infra/docker-compose.$(ENV).yml run --rm tf

.PHONY: run_plan
run_plan: init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: init
init: infra/.env
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

.PHONY: console
console:
	$(COMPOSE_RUN_TERRAFORM) console
################################

################################
### DOCKER
################################
export AWS_ACCOUNT_ID
export AWS_REGION 
export AWS_ECR_REPO_NAME 
IMAGE_NAME = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(AWS_ECR_REPO_NAME):latest
COMPOSE_RUN_AWS = docker-compose -f ./infra/docker-compose.yml -f ./infra/docker-compose.root.yml run --rm --entrypoint aws tf

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) -f ./app/Dockerfile ./app

.PHONY: push
push:
	docker image push $(IMAGE_NAME)

.PHONY: login_ecr
login_ecr: 
	$(COMPOSE_RUN_AWS) ecr get-login-password --region $(AWS_REGION) \
	| docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
################################