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

