Vagrant.configure("2") do |config|

	require 'json'

	config.vm.box = "precise64"

	config.cache.auto_detect = true
	config.cache.enable_nfs  = true

	local_config_encoded = File.read('config.json')
	local_config = JSON.parse(local_config_encoded)

	config.vm.synced_folder local_config['app'], "/www/app/", nfs: true

	# Enable private networking, set guest IP address
	config.vm.network :private_network, ip: "10.0.3.20"

    # Enable SSH agent forwarding
    config.ssh.forward_agent = true

	# Run provisioning scripts
	config.vm.provision "shell", inline: "/vagrant/provision/main.sh $*"

end
