# KT Challenger

## Scope

The scope of this demo is to create a docker swarm cluster that:

1. create 2 VMs that have all a dedicated volume to docker;
2. expose docker API securely;
3. docker daemon must run on the VM startup (in case of reboot)

## Requirements

### Vagrant Plugins

To use this demo with `vagrant` you need to install these plugins:

```
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-serverspec
vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-ansible-local
vagrant plugin install vagrant-hosts
vagrant plugin install vagrant-vbguest
vagrant plugin install vbinfo
```

### Hosts file

One pre-check requires that your host file must contains the following lines:

```
# /etc/hosts
192.168.1.101 swarm-manager docker.1
192.168.1.102 swarm-worker docker.2
```

## Start Demo

### Vagrant

Just launch this command:

```
vagrant up
```

When the VMs starter, connect to docker-swarm manager an try to list docker nodes:

```
vagrant ssh docker.1
sudo docker node ls

# example output
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
wpkl33f4c3jfn84reza7835ri *   docker.1            Ready               Active              Leader              19.03.12
9i80y96unibtwfdzrastzj617     docker.2            Ready               Active                                  19.03.12

```

The playbook already deploy a services to test that you can see here (nginx default page): http://192.168.42.102:8080/

(TCP DOCKER API EXPOSE TO: tcp://192.168.42.101:2376)

--------------------------------

## Notes

### Vagrant boxes

When I use `vagrant`, I prefer always to use [bento vagrant boxes](https://app.vagrantup.com/bento).

> These boxes are built using templates from the Chef's Bento project.

In particular, in [Vagrantfile](./Vagrantfile) is declared `bento/centos-8`
but it has an issue `docker-ce` and `containerd.io` [(workaround)](https://vexpose.blog/2020/04/02/installation-of-docker-fails-on-centos-8-with-error-package-containerd-io-1-2-10-3-2-el7-x86-64-is-excluded/).

### Shell tasks

To use the workaround previously described it was necessary use `shell` ansible module.
For ansible best practice, you should use this only when there aren't valid options to do "what you have to".

### Referecens

 - https://github.com/chef/bento
 - https://docs.docker.com/engine/install/centos/
 - https://www.vagrantup.com/docs/provisioning/shell
 - https://www.vagrantup.com/docs/providers/virtualbox
 - https://www.vagrantup.com/docs/disks/configuration
 - https://vexpose.blog/2020/04/02/installation-of-docker-fails-on-centos-8-with-error-package-containerd-io-1-2-10-3-2-el7-x86-64-is-excluded/
 - https://docs.docker.com/engine/security/https/
 - https://github.com/ansible/role-secure-docker-daemon
 - https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
 - https://github.com/jobin-james/docker-swarm/blob/master/docker-swarm.yml
 - https://github.com/monicagangwar/docker-swarm-vagrant
 - https://github.com/krol3/nginx-ansible-molecule/tree/master/roles/nginx/molecule/default
 - https://opensource.com/article/18/12/testing-ansible-roles-molecule
