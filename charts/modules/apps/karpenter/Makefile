NAMESPACE?=infra-dev-karpenter
RELEASE_NAME?=infra-aws-eks-karpenter
include ../../../../Makefile


.PHONY: helm-ecr-auth
helm-ecr-auth:
	${L}aws ecr-public get-login-password --region us-east-1 | \
		docker login --username AWS --password-stdin public.ecr.aws/karpenter
