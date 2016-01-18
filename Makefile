proxy_ami_id=$(shell tail -1 .proxy-packerout.log |cut -d" " -f 2)
node_ami_id=$(shell tail -1 .node-packerout.log |cut -d" " -f 2)

all:
	clean build-ami plan apply

build-ami:
	librarian-puppet install --path=./puppet/modules
	packer build packer/node.json 2>&1 | tee .node-packerout.log
	packer build packer/proxy.json 2>&1 | tee .proxy-packerout.log

plan:
	@terraform plan -out terraform/.tfplan -var 'ami_id=$(ami_id)' -var 'aws_access_key=$(AWS_ACCESS_KEY_ID)' -var 'aws_secret_key=$(AWS_SECRET_ACCESS_KEY)' ./terraform/

apply:
	@terraform apply -var 'ami_id=$(ami_id)' -var 'aws_access_key=$(AWS_ACCESS_KEY_ID)' -var 'aws_secret_key=$(AWS_SECRET_ACCESS_KEY)' ./terraform/

graph:
	@terraform graph ./terraform/

destroy:
	@terraform plan -destroy -out terraform/terraform.tfplan -var 'ami_id=$(ami_id)' -var 'aws_access_key=$(AWS_ACCESS_KEY_ID)' -var 'aws_secret_key=$(AWS_SECRET_ACCESS_KEY)' ./terraform/
	@terraform apply terraform/terraform.tfplan

clean:
	rm -rf .*packerout.log
	rm -rf ./.librarian
	rm -rf ./.tmp
	librarian-puppet clean
	mkdir -p ./puppet/modules
