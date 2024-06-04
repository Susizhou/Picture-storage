DIR = terraform/root_modules/${MODULE}
BUILD_REGION ?= "eu-west-2"

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

# Terraform
.PHONY: init
init: guard-MODULE ## Initialises the root module directory
	terraform -chdir=${DIR} init -upgrade \
		-backend-config="bucket=susizhou-picture-storage-terraform-state-backend" \
		-backend-config="dynamodb_table=terraform_state" \
		-backend-config="region=${BUILD_REGION}" \
		-reconfigure

.PHONY: plan
plan: guard-MODULE init ## Create plan for terraform changes
	terraform -chdir=${DIR} plan 

.PHONY: deploy
deploy: guard-MODULE init
	terraform -chdir=${DIR} apply
	