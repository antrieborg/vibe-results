# Retrieving $APPLICATION_USERNAME from LDAP Server via Ansible

## Prompt
> Write an Ansible playbook to connect to the ldap  server and retrieve the value of $APPLICATION_USERNAME.. Youare not asked to install anything. Simply return the ebv variabkle.

## Description
This Ansible playbook connects to an LDAP server to retrieve the value of the $APPLICATION_USERNAME variable.

## Files

* `inventory.ini`: Ansible inventory file
* `host_vars/node1.yml` and `host_vars/node2.yml`: Host-specific variables for nodes 1 and 2
* `group_vars/all.yml`: Global variables for all hosts in the inventory
* `ansible.cfg`: Ansible configuration file
* `playbook.yml`: Ansible playbook that retrieves the $APPLICATION_USERNAME variable from LDAP

## Iteration History
* Iteration 1 (1): success