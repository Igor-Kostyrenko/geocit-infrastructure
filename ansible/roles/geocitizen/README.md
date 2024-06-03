Role Name
=========

Geocitizen

Requirements
------------

- Linux host (Ubuntu 22.04)
- Ansible 2.9 or higher

Role Variables
--------------

The main variables for this role are listed below (see `defaults/main.yml` for default values)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - name: "Install dependencies for Geo Citizen app"
      hosts: servers
      become: true
      become_method: sudo
      roles:
        - {role: geocitizen, when: ansible_system =='Linux'}

## Installation Steps
- Install Java
- Install Maven
- Install Tomcat Service