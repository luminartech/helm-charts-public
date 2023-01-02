HELM_BINARY?=helm
EXTRA_HELM_ARGS?=
TEMPLATE_OUTPUT_FILE?=templated-output.yaml
RELEASE_NAME?=${ENVIRONMENT}-${CHART_NAME}
VALUES_FILE= --values ./values.yaml
ifneq (,$(wildcard values-test.y*l))
VALUES_FILE+= --values ./values-test.yaml
endif
ifneq (,$(wildcard values-local.y*l))
VALUES_FILE+= --values ./values-local.yaml
endif

.PHONY: helm-chart-build
helm-chart-build: validate-helm-dir
	${L}${HELM_BINARY} dependency build ./

.PHONY: helm-chart-update-all
helm-chart-update-all:
	${L}set +e ;\
		for d in $$(find . -maxdepth 1 -mindepth 1 -type d); do \
			cd $$d ;\
			make helm-chart-update ;\
			cd .. ;\
		done

.PHONY: helm-chart-update
helm-chart-update: validate-helm-dir
	${L}${HELM_BINARY} dependency update ./

.PHONY: helm-chart-template
helm-chart-template: validate-helm-dir
	${L}set +e ;\
		${HELM_BINARY} template ${RELEASE_NAME} ./ \
			--debug \
			${EXTRA_HELM_ARGS} \
			${VALUES_FILE} ;\
		exitCode=$$? ;\
		exit $$exitCode

.PHONY: helm-chart-test
helm-chart-test: validate-helm-dir
	${L}set +e ;\
		${HELM_BINARY} template ${RELEASE_NAME} ./ \
			--namespace ${NAMESPACE} \
			${EXTRA_HELM_ARGS} \
			${VALUES_FILE} | kubectl apply --dry-run=server -f - ;\
		exitCode=$$? ;\
		exit $$exitCode

.PHONY: helm-chart-local-deploy
helm-chart-local-deploy: validate-helm-dir
	${L}${HELM_BINARY} upgrade -i ${RELEASE_NAME} ./ --wait \
	--create-namespace \
	--namespace ${NAMESPACE} \
	${EXTRA_HELM_ARGS} \
	${VALUES_FILE}

.PHONY: helm-chart-local-delete
helm-chart-local-delete: validate-helm-dir
	${L}${HELM_BINARY} uninstall ${RELEASE_NAME} \
	--namespace ${NAMESPACE}

.PHONY: helm-chart-local-out
helm-chart-local-out: validate-helm-dir
	${L}set +e ;\
		${HELM_BINARY} template ${RELEASE_NAME} ./ \
			--namespace ${NAMESPACE} \
			--debug \
			${EXTRA_HELM_ARGS} \
			${VALUES_FILE} > ${TEMPLATE_OUTPUT_FILE} ;\
		exitCode=$$? ;\
		exit $$exitCode

.PHONY: validate-helm-dir
validate-helm-dir:
	${L}if [[ "${REPO_ROOT}" == "$$(pwd)" || ! -f Chart.yaml ]]; then \
			echo "ERROR: Make commands needs to be executed inside a helm chart directory" ;\
			exit 1 ;\
		fi

.PHONY: add-helm-plugin-diff
add-helm-plugin-diff:
	${L}${HELM_BINARY} plugin install https://github.com/databus23/helm-diff || true
