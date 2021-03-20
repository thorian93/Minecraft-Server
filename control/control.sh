#!/bin/bash
# Written by: Robin Gierse - info@thorian93.de - on 20201219
#
# Purpose:
# This script manages the project with ansible and terraform.
#
# Version: 0.1 on 20201219
# Version: 0.2 on 20201220
# Version: 0.3 on 20210214 - Add TF_VAR_hcloud_token and central project naming
#
# Usage:
# ./control.sh -m <MODE> -t <TOKEN>

set -e

# Variables
control_project_name='minecraft'
control_scriptdir="$(dirname "$0")"
control_hcloud_timeout='30'

while getopts ":m:t:" opt; do
  case $opt in
    m)
	  control_mode="$OPTARG"
	  ;;
    t)
	  HCLOUD_TOKEN="$OPTARG"
	  ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

_help() {
    echo 'Wrong mode! Choose one of the following:'
    echo ''
    echo 'ansible       - Prepare the project to run ansible'
    echo 'bootstrap     - Start the project from scratch'
    echo 'init          - Only initialize terraform and ansible roles'
    echo 'run           - Run the project without terraform initialization'
    echo 'destroy       - Destroy the project'
    echo 'unset         - Unset environment'
}

_initialize() {
    if [ -z "$HCLOUD_TOKEN" ]
    then
        echo 'No token provided! Use "-t"'
        exit 1
    else
        export HCLOUD_TOKEN
        export TF_VAR_hcloud_token="${HCLOUD_TOKEN}"
    fi
}

_initialize_terraform() {
    _initialize
    cd "${control_scriptdir}/../terraform" || exit 1
    echo 'Terraform preparing the planet ...'
    terraform init -var hcloud_token="$HCLOUD_TOKEN"
    echo ''
}

_initialize_ansible() {
    _initialize
    cd "${control_scriptdir}/../ansible" || exit 1
    echo 'Ansible exploring the galaxy ...'
    ansible-galaxy install -r roles/requirements.yml
    echo ''
}

_run_project() {
    cd "${control_scriptdir}/../terraform" || exit 1
    echo 'Terraform working the planet ...'
    terraform plan -out "${control_project_name}".plan -var hcloud_token="$HCLOUD_TOKEN"
    terraform apply "${control_project_name}".plan
    echo ''
    cd "${control_scriptdir}/../ansible" || exit 1
    echo 'Waiting for the ecosphere ...'
    sleep "${control_hcloud_timeout}"
    echo 'Ansible taking off ...'
    ansible-playbook -i inventory/hcloud.py playbooks/bootstrap.yml
}

_destroy_project() {
    cd "${control_scriptdir}/../ansible" || exit 1
    echo 'Saving Server State ...'
    ansible-playbook -i inventory/hcloud.py playbooks/main.yml --tags destroy
    cd "${control_scriptdir}/../terraform" || exit 1
    echo 'Burning it all down ...'
    terraform destroy -auto-approve -var hcloud_token="$HCLOUD_TOKEN"
}

_unset() {
    unset HCLOUD_TOKEN
}

# Main
case $control_mode in
ansible)
    _initialize_ansible
    ;;
bootstrap)
    _initialize_terraform
    _initialize_ansible
    _run_project
    _unset
    ;;
init)
    _initialize_terraform
    _initialize_ansible
    ;;
run)
    _initialize_ansible
    _run_project
    _unset
    ;;
destroy)
    _initialize
    _destroy_project
    _unset
    ;;
unset)
    _unset
    ;;
*)
    _help ; exit 1
    ;;
esac