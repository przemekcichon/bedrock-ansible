#!/bin/bash
#
# Windows provisioner for bedrock-ansible
# based on KSid/windows-vagrant-ansible
# @author Andrea Brandi
# @version 1.0
 
ANSIBLE_PLAYBOOK=$1
ANSIBLE_HOSTS=$2
TEMP_HOSTS="/tmp/ansible_hosts"
 
if [ ! -f /vagrant/$ANSIBLE_PLAYBOOK ]; then
  echo "Ansible playbook not found."
  exit 1
fi
 
if [ ! -f /vagrant/$ANSIBLE_HOSTS ]; then
  echo "Ansible hosts not found."
  exit 2
fi
 
# Create an ssh key if not already created.
if [ ! -f ~/.ssh/id_rsa ]; then
  echo -e "\n\n\n" | ssh-keygen -t rsa
fi
 
# Install Ansible and its dependencies if not installed.
if [ ! -f /usr/bin/ansible ]; then
  echo "Adding Ansible repository..."
  sudo apt-add-repository ppa:rquillo/ansible
  echo "Updating system..."
  sudo apt-get -y update
  echo "Installing Ansible..."
  sudo apt-get -y install ansible
fi
 
cp /vagrant/${ANSIBLE_HOSTS} ${TEMP_HOSTS} && chmod -x ${TEMP_HOSTS}
echo "Running Ansible provisioner defined in Vagrantfile..."
ansible-playbook /vagrant/${ANSIBLE_PLAYBOOK} --inventory-file=${TEMP_HOSTS} --sudo --user=vagrant --extra-vars "default_ssh_user=vagrant is_windows=true" --connection=local
rm ${TEMP_HOSTS}