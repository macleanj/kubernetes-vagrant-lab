# -*- mode: ruby -*-
# vi: set ft=ruby :

install_kubeadm = 1
setup_cluster = 1
setup_loadbalancer = 0 # TODO: See https://medium.com/faun/configuring-ha-kubernetes-cluster-on-bare-metal-servers-with-kubeadm-1-2-1e79f0f7857b for continuation of HA cluster
docker_version = "5:18.09.9~3-0~ubuntu-bionic" # Get version by: apt-cache madison docker-ce
k8_version = "1.16.1-00" # One subversion less to enable upgrade tests. "1.15.4-00" for CKA exam
cni_provider = "calico" # "calico|flannel" where calico is the default
vagrant_default_provider = "virtualbox"
glusterfs_version = "6.6"
laptopIp = "192.168.1.99" # Secondary "always up" interface for offline demos

# TODO: See https://medium.com/faun/configuring-ha-kubernetes-cluster-on-bare-metal-servers-with-kubeadm-1-2-1e79f0f7857b for continuation of HA cluster
# loadbalancer=[
#   {
#     :hostname => "loadbalancer",
#     :type => "loadbalancer",
#     :box => "ubuntu/bionic64",
#     :box_version => "20191010.0.0",
#     :ip => "10.16.0.1",
#     :mem => "1024",
#     :cpu => "1",
#     :disksize => "10GB"
#     # :ssh_port => '2201'
#   }
# ]

servers=[
  {
    :hostname => "master-0",
    :type => "control-plane",
    :box => "ubuntu/bionic64",
    :box_version => "20191010.0.0",
    :ip => "10.16.0.10",
    :mem => "4096",
    :cpu => "4",
    :disksize => "10GB"
    # :ssh_port => '2210'
  },
  # {
  #   :hostname => "master-1",
  #   :type => "control-plane",
  #   :box => "ubuntu/bionic64",
  #   :box_version => "20191010.0.0",
  #   :ip => "10.16.0.11",
  #   :mem => "2048",
  #   :cpu => "2",
  #   :disksize => "10GB"
  #   # :ssh_port => '2211'
  # },
  # {
  #   :hostname => "master-2",
  #   :type => "control-plane",
  #   :box => "ubuntu/bionic64",
  #   :box_version => "20191010.0.0",
  #   :ip => "10.16.0.12",
  #   :mem => "2048",
  #   :cpu => "2",
  #   :disksize => "10GB"
  #   # :ssh_port => '2212'
  # },
  {
    :hostname => "node-0",
    :type => "worker",
    :box => "ubuntu/bionic64",
    :box_version => "20191010.0.0",
    :ip => "10.16.0.20",
    :mem => "4096",
    :cpu => "2",
    :disksize => "15GB"
    # :ssh_port => '2220'
  },
  {
    :hostname => "node-1",
    :type => "worker",
    :box => "ubuntu/bionic64",
    :box_version => "20191010.0.0",
    :ip => "10.16.0.21",
    :mem => "4096",
    :cpu => "2",
    :disksize => "15GB"
    # :ssh_port => '2221'
  },
  # {
  #   :hostname => "node-2",
  #   :type => "worker",
  #   :box => "ubuntu/bionic64",
  #   :box_version => "20191010.0.0",
  #   :ip => "10.16.0.22",
  #   :mem => "2048",
  #   :cpu => "1",
  #   :disksize => "15GB"
  #   # :ssh_port => '2222'
  # }
]

# Get master and worker information consolidated
# loadbalancerIp = ''
mastersCount = 0
masterIps = 'undefined'
workerIps = 'undefined'
servers.each do |server|
  if ( server[:type] == "control-plane" )
    if masterIps == 'undefined'
      masterIps=server[:ip]
    else
      masterIps=masterIps + "," + server[:ip]
    end
    mastersCount += 1
  else
    if workerIps == 'undefined'
      workerIps=server[:ip]
    else
      workerIps=workerIps + "," + server[:ip]
    end
  end
end

Vagrant.configure("2") do |config|

  # if ( setup_loadbalancer == 1 )
  #   loadbalancerIp=loadbalancer[:ip]

  #   config.vm.define loadbalancer[:hostname] do |config|
  #     ENV['VAGRANT_DEFAULT_PROVIDER'] = vagrant_default_provider
  #     config.vm.box = loadbalancer[:box]
  #     config.vm.box_version = loadbalancer[:box_version]
  #     config.vm.hostname = loadbalancer[:hostname]

  #     config.vm.network :private_network, ip: loadbalancer[:ip]
  #     # config.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
  #     config.vm.network "forwarded_port", guest: 6443, host: 6443, id: "lb-kube-api"

  #     config.vm.provider :virtualbox do |v|
  #       v.customize ["modifyvm", :id, "--name", loadbalancer[:hostname]]
  #       v.customize ["modifyvm", :id, "--memory", loadbalancer[:mem]]
  #       v.customize ["modifyvm", :id, "--cpus", loadbalancer[:cpu]]
  #     end

  #     config.vm.provision :shell, privileged: true, path: 'setup-loadbalancer', args: "#{docker_version}"

  #   end
  # end

  servers.each do |machine|

    config.vm.define machine[:hostname] do |config|
      ENV['VAGRANT_DEFAULT_PROVIDER'] = vagrant_default_provider
      config.vm.box = machine[:box]
      config.vm.box_version = machine[:box_version]
      config.vm.hostname = machine[:hostname]
      config.disksize.size = machine[:disksize]

      config.vm.network :private_network, ip: machine[:ip]
      # config.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"

      config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--name", machine[:hostname]]
        v.customize ["modifyvm", :id, "--memory", machine[:mem]]
        v.customize ["modifyvm", :id, "--cpus", machine[:cpu]]
      end

      # Setup OS, system, prerequisites, and Docker
      config.vm.provision :shell, privileged: true, path: 'install-generic', args: "#{docker_version} #{glusterfs_version}"

      if ( install_kubeadm == 1 )
        config.vm.provision :shell, privileged: true, path: 'install-kubeadm', args: "#{k8_version}"
      end

      # TODO: See https://medium.com/faun/configuring-ha-kubernetes-cluster-on-bare-metal-servers-with-kubeadm-1-2-1e79f0f7857b for continuation of HA cluster
      if ( setup_cluster == 1 )
        if ( machine[:type] == "control-plane" && machine[:hostname] == "master-0" )
          masterIp = machine[:ip]
          config.vm.network "forwarded_port", guest: 6443, host: 6443, id: "kube-api"
          config.vm.network "forwarded_port", guest: 2379, host: 2379, id: "etcd-api"
          config.vm.provision :shell, path: 'setup-master', privileged: true, args: "#{laptopIp} #{machine[:ip]} #{masterIp} #{masterIps} #{workerIps} #{cni_provider}"
        else
          config.vm.provision :shell, path: 'setup-worker', privileged: true, args: "#{laptopIp} #{machine[:ip]} #{masterIp} #{masterIps} #{workerIps} #{cni_provider}"
        end
      end  

    end

  end

  id_rsa_key_pub = File.read(File.join(Dir.home, "Services/System/Config/cred", "vagrant-rsa.pub"))
  config.vm.provision :shell,
    :inline => "echo 'appending SSH public key to ~vagrant/.ssh/authorized_keys' && echo '#{id_rsa_key_pub }' >> /home/vagrant/.ssh/authorized_keys && chmod 600 /home/vagrant/.ssh/authorized_keys"

  config.ssh.insert_key = false
end