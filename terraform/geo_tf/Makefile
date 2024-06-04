GEO_ENV?=dev-01-eu-west-3-geo

init:
	terraform init
	terraform workspace select -or-create ${GEO_ENV}

plan: init
	terraform plan -var-file=./workspace_vars/$(GEO_ENV).json

apply: init
	terraform apply -var-file=./workspace_vars/$(GEO_ENV).json