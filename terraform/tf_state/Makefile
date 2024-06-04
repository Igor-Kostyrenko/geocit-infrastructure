GEO_ENV?=dev-01-europe-west3-geo

init:
	terraform init -no-color
	terraform workspace select -or-create ${GEO_ENV}

plan: init
	terraform plan -var-file=./workspace_vars/$(GEO_ENV).json -no-color

apply: init
	terraform apply -var-file=./workspace_vars/$(GEO_ENV).json -auto-approve -no-color
destroy: init
	terraform destroy -var-file=./workspace_vars/$(GEO_ENV).json -auto-approve -no-color