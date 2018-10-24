CLUSTER ?= fargate

AWS_DEFAULT_REGION := us-east-1
IAM_ROLE ?= atlantis

include $(shell curl --silent -o .build-harness "https://raw.githubusercontent.com/cloudposse/build-harness/master/templates/Makefile.build-harness"; echo .build-harness)


install:
	apk add --update $$(grep -v '^#' packages.txt)
	ln -s $$(pwd)/atlantis-server /etc/init.d/atlantis-server.sh
	curl -o /usr/bin/atlantis https://github.com/cloudposse/atlantis/releases/download/0.5.2/atlantis_linux_amd64
	chmod 755 /usr/bin/atlantis

## Run atlantis (for local development)
docker/run:
	docker run -e ATLANTIS_ENABLED=true -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_SECURITY_TOKEN -it $(ATLANTIS_IMAGE)

## Provision IAM role
create/iam-role:
	aws iam create-role --role-name "$(IAM_ROLE)" --assume-role-policy-document file://./task-execution-assume-role.json
	aws iam attach-role-policy --role-name "$(IAM_ROLE)" --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

## Provision ACM certificate
create/certificate:
	fargate certificate request "$(ATLANTIS_DOMAIN)" --alias "$(ATLANTIS_HOSTNAME)"

## Validate ACM certificate
validate/certificate:
	fargate certificate validate "$(ATLANTIS_DOMAIN)"

## Destroy ACM certificate
destroy/certificate:
	fargate certificate destroy "$(ATLANTIS_DOMAIN)"

## Create ALB
create/lb:
	fargate lb create atlantis \
		--cluster "$(CLUSTER)" \
		--certificate "$(ATLANTIS_DOMAIN)" \
		--port HTTPS:443

## Destroy ALB
destroy/lb:
	fargate lb destroy atlantis

## Create ALB Route53 Alias
create/lb/alias:
	fargate lb alias atlantis "$(ATLANTIS_HOSTNAME)"

## Create ECS Service
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

## Destroy ECS service
destroy/service:
	fargate service scale atlantis 0
	fargate service destroy atlantis

## Describe status of ECS Service
info:
	fargate service info atlantis

## Tail logs from ECS service
logs:
	fargate service logs atlantis --start -1h --follow

## Deploy one-off ECS task (not recommended)
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

## Destroy one-off task
destroy/task:
	fargate task stop atlantis

## Deploy the latest image
deploy:
	fargate service deploy atlantis --image "$(ATLANTIS_IMAGE)"
