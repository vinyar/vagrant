Vagrant.configure("2") do |config|

    # Read configuration from `config.json` file.
    require 'json'
    local_config_encoded = File.read('config.json')
    local_config = JSON.parse(local_config_encoded)

    config.vm.provider "virtualbox" do |v|
        v.name = local_config["id"]
    end

    # Set box type based on configuration. Defaults to `precise64` (Ubuntu).
    # The URL that you see below is from Vagrant's own list of available boxes:
    # http://www.vagrantbox.es/
	if !local_config["box"]
        config.vm.box = "precise64"
        config.vm.box_url = "http://files.vagrantup.com/precise64.box"
	else
        config.vm.box = local_config["box"]
        config.vm.box_url = local_config["box_url"]
	end

	# Set IP Address
    config.vm.network :private_network, ip: local_config["guest_ip"]

    # Setup port forwarding
    # config.vm.network :forwarded_port, guest: 3000, host: 3000

    # Enable SSH agent forwarding
    config.ssh.forward_agent = true

    # Loop through configured path maps.
    local_config["paths"].each do |local_path, remote_path|
        config.vm.synced_folder local_path, remote_path, nfs: true
    end

    provision_cmd = "/vagrant/provision.sh "
    local_config["scripts"].each do |script, key|
        provision_cmd = provision_cmd + script + " "
    end

    config.vm.provision "shell", inline: provision_cmd

end
