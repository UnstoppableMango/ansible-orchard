CLUSTER_NAME ?= orchard
KUBECONFIG ?= .kind/kubeconfig
AWX_NAMESPACE ?= awx
AWX_OPERATOR_VERSION ?= 3.2.1
KIND_EXPERIMENTAL_PROVIDER ?= podman

export KUBECONFIG
export KIND_EXPERIMENTAL_PROVIDER

.PHONY: cluster-start
cluster-start: .kind/kubeconfig

.kind/kubeconfig: .kind/config.yaml
	kind create cluster --name $(CLUSTER_NAME) --config $<
	kind get kubeconfig --name $(CLUSTER_NAME) > $@

.PHONY: cluster-stop
cluster-stop:
	kind delete cluster --name $(CLUSTER_NAME)
	rm -f .kind/kubeconfig

build: context/Containerfile
	ansible-builder build -f execution-environment/execution-environment.yml

update:
	nix flake update

check lint:
	nix flake check

format fmt:
	nix fmt

context/Containerfile: execution-environment/execution-environment.yml
	ansible-builder create -f $<

.PHONY: awx-install
awx-install:
	helm repo add awx-operator https://ansible-community.github.io/awx-operator-helm/
	helm repo update
	helm upgrade --install awx-operator awx-operator/awx-operator \
		--version $(AWX_OPERATOR_VERSION) \
		--namespace $(AWX_NAMESPACE) \
		--create-namespace
	kubectl create namespace $(AWX_NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f k8s/awx/awx.yaml

.PHONY: awx-uninstall
awx-uninstall:
	kubectl delete -f k8s/awx/awx.yaml --ignore-not-found
	helm uninstall awx-operator --namespace $(AWX_NAMESPACE) --ignore-not-found
	kubectl delete namespace $(AWX_NAMESPACE) --ignore-not-found

.PHONY: awx-status
awx-status:
	kubectl get awx,pods,svc -n $(AWX_NAMESPACE)

.PHONY: awx-password
awx-password:
	kubectl get secret awx-admin-password -n $(AWX_NAMESPACE) -o jsonpath='{.data.password}' | base64 --decode && echo

