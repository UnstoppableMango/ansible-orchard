build:
	nix build .#

update:
	nix flake update

check lint:
	nix flake check

format fmt:
	nix fmt

.ansible/Containerfile: execution-environment/execution-environment.yml execution-environment/requirements.txt execution-environment/ansible-requirements.yml
	ansible-builder build -f execution-environment/execution-environment.yml

