# Ansible

---

## Whoami

* Haïkel Guémar (@hguemar)
* Senior Software Engineer (marque blanche)
* Développeur Fedora depuis 2006
* Membre de l'APRIL, Openstack FR etc.
* Trolleur patenté

<img src="img/me.jpg" />

---

## Ansible: supra-luminic IT automation

<img src="img/ansible_logo_round.png" width="100" />

---

## Différents Niveaux de la gestion de configurations

* shell distant: ssh, pssh, func
* Orchestration: Fabric, Capistrano
* gestion de configuration: CFEngine, Puppet, Chef

---

## Installer Ansible

    !bash
    # yum install ansible
    # apt-get install ansible
    # pip install ansible

Très peu de dépendances:

+ contrôleur: python, paramiko, PyYAML, jinja2, httplib2
+ minions: python 2.5+

---

# concepts

---

## Inventaire d'hôtes

    # /etc/ansible/hosts
    ldap.example.com
    [webapps]
    web[0:8].example.com
    [database]
    db-[a:c].example.com ansible_ssh_user=postgres
    [prod]
    web
    database

---

# modules

* gestion de paquets (apt, yum, pkgin, pacman, macports)
* cloud (AWS, openstack, GCE)
* base de données (mysql, postgresql, mongodb)
* serveurs (apache, nagios, rabbitmq)
* virtualisation (kvm, xen, docker, vagrant)
* système: utilisateurs, groupes, fichiers, quotas, cron etc.
* les votres !

---

# modules en action

    !bash
    $ ansible all -m ping
    $ ansible prod -m yum -a name=\* state=latest
    $ ansible !db -m yum -a name=\* state=latest

---

## Pas d'agent !

<img src="img/ssh.jpg" height="500" />

---

## Une exception: mode accéléré 

    !yaml
    # requiert python 2.5+, python-keyczar
    - hosts: web
      accelerate: true
      # accelerate_port: 5099

---

## Playbook

<img src="img/neil-patrick-harris1-1024x768.jpg" height="500" />

---

## Playbook

    !yaml
    - name: check/create webservers
      hosts: webservers
      user: root

      tasks:
      - name: install httpd
        action: yum state=installed name=$item
        with_items: 
        - httpd
        - mod_wsgi
        - postgresql-server
      - name:
        service: name=httpd enabled=yes state=started
---

## Playbook

    !bash
    $ ansible-playbook check.yml

---

## Playbook

+ variables
+ templates
+ roles
+ handlers
+ includes
+ ansible-pull

---

# Récapitulatif

---

## Architecture

<img src="img/ANSIBLE_DIAGRAM.jpg" />

---

## Donc ...

+ installer Ansible
+ créer son inventaire
+ installer l'agent // IT'S A TRAP !
+ automatiser

---

## Cloud Ready !

<img src="img/cloud_ready.jpg" height="400" />

---

## Plus d'infos

docs.ansible.com

galaxy.ansible.com

---

## One More thing: Ansible RDO playbooks

https://github.com/ansible/ansible-redhat-openstack

    !bash
    $ ansible-playbook -i hosts site.yml
    $ ansible-playbook -i hosts playbooks/image.yml -e "image_name=cirros image_url=https://launchpad.net/cirros/trunk/0.3.0/+download/cirros-0.3.0-x86_64-disk.img"

---

## I did it again !

CentOS dojo à Lyon le 11 avril @Epitech

![centos](img/centoslogo-200.png)

Plus d'informations sur le wiki CentOS: 
http://wiki.centos.org/Events/Dojo/Lyon2014

---

# Q/A