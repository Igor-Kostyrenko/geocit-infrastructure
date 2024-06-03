GEO_ENV?=dev-01-eu-west-3-geo

init:
	terraform init
	terraform workspace select -or-create ${GEO_ENV}.json

plan: init
	terraform plan -var-file=env/$(GEO_ENV).tfvars

apply: init
	terraform apply -var-file=env/$(GEO_ENV).tfvars