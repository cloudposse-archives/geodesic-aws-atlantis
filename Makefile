CLUSTER ?= fargate

AWS_DEFAULT_REGION := us-east-1
IAM_ROLE ?= atlantis

install:
	apk add --update $$(grep -v '^#' packages.txt)
	ln -s $$(pwd)/atlantis-server /etc/init.d/atlantis-server.sh
	curl -o https://github.com/cloudposse/atlantis/releases/download/0.5.2/atlantis_linux_amd64 /usr/bin/atlantis
	chmod 755 /usr/bin/atlantis

docker/run:
	docker run -e ATLANTIS_ENABLED=true -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_SECURITY_TOKEN -it $(ATLANTIS_IMAGE)

create/iam-role:
	aws iam create-role --role-name "$(IAM_ROLE)" --assume-role-policy-document file://./task-execution-assume-role.json
	aws iam attach-role-policy --role-name "$(IAM_ROLE)" --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

create/certificate:
	fargate certificate request "$(ATLANTIS_DOMAIN)" --alias "$(ATLANTIS_HOSTNAME)"

validate/certificate:
	fargate certificate validate "$(ATLANTIS_DOMAIN)"

destroy/certificate:
	fargate certificate destroy "$(ATLANTIS_DOMAIN)"

create/lb:
	fargate lb create atlantis \
		--cluster "$(CLUSTER)" \
		--certificate "$(ATLANTIS_DOMAIN)" \
		--port HTTPS:443

destroy/lb:
	fargate lb destroy atlantis

create/lb/alias:
	fargate lb alias atlantis "$(ATLANTIS_HOSTNAME)"

create/service:
	fargate service create atlantis \
		--cluster "$(CLUSTER)" \
		--lb atlantis \
		--num 1 \
		--cpu 256 \
		--memory 2048 \
		--port "HTTP:4141" \
		--rule "PATH=/*" \
		--env "ATLANTIS_ENABLED=true" \
		--env "AWS_REGION=us-west-2" \
		--env "TF_VAR_aws_assume_role_arn=atlantis" \
		--task-role "$(IAM_ROLE)" \
		--image "$(ATLANTIS_IMAGE)"

destroy/service:
	fargate service scale atlantis 0
	fargate service destroy atlantis


info:
	fargate service info atlantis

logs:
	fargate service logs atlantis --start -1h --follow

create/task:
	fargate task run atlantis \
		--cluster "$(CLUSTER)" \
		--num 1 \
		--cpu 256 \
		--memory 2048 \
		--env "ATLANTIS_ENABLED=true" \
		--port "HTTP:4141" \
		--task-role "$(IAM_ROLE)" \
		--image "$(ATLANTIS_IMAGE)"

destroy/task:
	fargate task stop atlantis

deploy:
	fargate service deploy atlantis --image "$(ATLANTIS_IMAGE)"

