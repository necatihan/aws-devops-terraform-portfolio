PROJECT ?=
TF_DIR := projects/$(PROJECT)

.PHONY: help
help:
	@echo "Examples:"
	@echo "  make init PROJECT=02-serverless-gha"
	@echo "  make plan PROJECT=02-serverless-gha"
	@echo "  make apply PROJECT=02-serverless-gha"
	@echo "  make destroy PROJECT=02-serverless-gha"

.PHONY: fmt
fmt:
	terraform fmt -recursive

.PHONY: init
init:
	cd $(TF_DIR) && terraform init

.PHONY: plan
plan:
	cd $(TF_DIR) && terraform plan

.PHONY: apply
apply:
	cd $(TF_DIR) && terraform apply

.PHONY: destroy
destroy:
	cd $(TF_DIR) && terraform destroy
