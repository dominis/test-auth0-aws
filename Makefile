proxy_ami_id=$(shell tail -1 .proxy-packerout.log |cut -d" " -f 2)
node_ami_id=$(shell tail -1 .node-packerout.log |cut -d" " -f 2)

all: clean build-ami plan apply

build-ami: build-ami-node build-ami-proxy

build-ami-node:
	librarian-puppet install --path=./puppet/modules
	packer build packer/node.json 2>&1 | tee .node-packerout.log

build-ami-proxy:
	librarian-puppet install --path=./puppet/modules
	packer build packer/proxy.json 2>&1 | tee .proxy-packerout.log

plan:
	@terraform get ./terraform/
	@terraform plan -out terraform/.tfplan -var 'node_ami_id=$(node_ami_id)' -var 'proxy_ami_id=$(proxy_ami_id)' -var 'aws_access_key=$(AWS_ACCESS_KEY_ID)' -var 'aws_secret_key=$(AWS_SECRET_ACCESS_KEY)' ./terraform/

apply:
	@terraform get ./terraform/
	@terraform apply -var 'node_ami_id=$(node_ami_id)' -var 'proxy_ami_id=$(proxy_ami_id)' -var 'aws_access_key=$(AWS_ACCESS_KEY_ID)' -var 'aws_secret_key=$(AWS_SECRET_ACCESS_KEY)' ./terraform/

graph:
	@terraform graph ./terraform/ | dot -Tpng > graph.png

destroy:
	@terraform get ./terraform/
	@terraform plan -destroy -out terraform/terraform.tfplan -var 'node_ami_id=$(node_ami_id)' -var 'proxy_ami_id=$(proxy_ami_id)' -var 'aws_access_key=$(AWS_ACCESS_KEY_ID)' -var 'aws_secret_key=$(AWS_SECRET_ACCESS_KEY)' ./terraform/
	@terraform apply terraform/terraform.tfplan

clean:
	rm -rf .*packerout.log
	rm -rf ./.librarian
	rm -rf ./.tmp
	librarian-puppet clean
	mkdir -p ./puppet/modules
