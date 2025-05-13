# Vagrantfile para un clúster OKD minimalista 🏗️
Vagrant.configure("2") do |config|
  # Box base: Ubuntu 20.04 LTS
  config.vm.box = "generic/ubuntu2004"

  # Configuración de nodos del clúster
  nodes = {
    "okd-master" => { ip: "192.168.56.10", memory: 8192, cpus: 4 },
    "okd-worker1" => { ip: "192.168.56.11", memory: 8192, cpus: 4 },
    "okd-worker2" => { ip: "192.168.56.12", memory: 8192, cpus: 4 }
  }

  # Configuración común para todos los nodos
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 8192
    vb.cpus = 4
  end

  # Configuración de cada nodo
  nodes.each do |name, opts|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: opts[:ip]
      node.vm.provider "virtualbox" do |vb|
        vb.memory = opts[:memory]
        vb.cpus = opts[:cpus]
      end
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "ansible/playbook.yml"
        ansible.limit = name
      end
    end
  end
end