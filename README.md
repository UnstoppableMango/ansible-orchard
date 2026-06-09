Minimal Ansible layout.

Run the SAML setup playbook:

ansible-playbook playbooks/saml-setup.yml -e "aap_user=admin aap_pass=SECRET aap_url=https://aap.example.com idp_metadata_url=https://idp.example.com/metadata"
