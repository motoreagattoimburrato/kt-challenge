# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # destination VMs: Kiratech Challege ( Centos 8 - to date)
  (1..2).each do |box_id|
    config.vm.define "docker.#{box_id}" do |box|

      box.vm.hostname = "docker.#{box_id}"
      box.vm.network "private_network", ip: "192.168.42.#{100+box_id}"
      #box.vm.network "forwarded_port", guest: 3306, host: 3306, auto_correct: true
      box.vm.box = "bento/centos-8"

      box.vm.provider "virtualbox" do |vb|
        file_to_disk = "docker_#{box_id}.vdi"
        vb.memory = "1024"
        vb.cpus = "1"
        unless File.exist?(file_to_disk)
          vb.customize [ 'createhd', '--filename', file_to_disk, '--size', 1024 * 40 ]
        end
        vb.customize [ 'storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk ]
      end

      box.vm.provision "shell", path: "scripts/init.sh"
      box.vm.provision "shell", path: "scripts/volume.sh"

      if box_id == 2
        box.vm.provision "ansible" do |ansible|
          ansible.limit = "all"
          ansible.become = true
          ansible.verbose = "vv"
          ansible.playbook = "./deploy_docker_swarm_playbook.yml"
          ansible.galaxy_role_file = "./requirements.yml"
          ansible.groups = {
            "docker_cluster" => ["docker.1", "docker.2"]
          }
        end
      end

    end
  end
end
