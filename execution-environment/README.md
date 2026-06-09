This execution environment definition is for ansible-builder.

Build the EE image with:

  ansible-builder build --tag orchard-ee -f execution-environment/execution-environment.yml

Then run the playbook using the built image, mounting the repo as the project directory:

  docker run --rm -v "$(pwd):/runner/project" orchard-ee ansible-playbook playbooks/saml-setup.yml -e "aap_user=admin aap_pass=SECRET aap_url=https://aap.example.com idp_metadata_url=https://idp.example.com/metadata"

Notes:
- requirements.txt installs ansible-core, ansible-runner and requests (required by uri module).
- Add Galaxy collections to ansible-requirements.yml and rebuild if needed.
