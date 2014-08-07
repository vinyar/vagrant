def configVirtualBox(instance, server, local_config, config)

    instance.cache.auto_detect = true;

    instance.vm.provider "virtualbox" do |v|

        v.name = server["id"]

        if !server["cpus"]
            v.customize [ "modifyvm", :id, "--cpus", "1" ]
        else
            v.customize [ "modifyvm", :id, "--cpus", server["cpus"] ]
        end

        if !server["memory"]
            v.customize [ "modifyvm", :id, "--memory", "512" ]
        else
            v.customize [ "modifyvm", :id, "--memory", server["memory"] ]
        end

        v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]

    end

    # Set box type based on configuration. Defaults to `precise64` (Ubuntu).
    # The URL that you see below is from Vagrant's own list of available boxes:
    # http://www.vagrantbox.es/
    if !server["box"]
        instance.vm.box = "precise64"
        instance.vm.box_url = "http://files.vagrantup.com/precise64.box"
    else
        instance.vm.box = server["box"]
        instance.vm.box_url = server["box_url"]
    end

    # Set IP Address
    instance.vm.network :private_network, ip: server["guest_ip"]

    # Setup port forwarding
    server["host_port_forwarding"].each do |ports|
        instance.vm.network :forwarded_port, guest: ports["guest"], host: ports["host"]
    end

    # Enable SSH agent forwarding
    config.ssh.forward_agent = true

    # Run provisioning scripts
    # Global
    server["host_scripts"].each do |script, key|
        instance.vm.provision :host_shell do |host_shell|
            host_shell.inline = './host_scripts/' + script
        end
    end

    # Loop through configured path maps.
    server["paths"].each do |local_path, remote_path|
        instance.vm.synced_folder local_path, remote_path, type: "nfs", nfs_udp: true
    end

    if server["guest_hostname"]
        instance.vm.hostname = server["guest_hostname"]
    end

    # Guest provisioning

    # ngrok
    local_config["servers"].each do |tsk, this_server|
        if this_server["ngrok_token"]
            ngrok_cmd = "echo \"auth_token: " + this_server["ngrok_token"] + "\" >> ~/.ngrok"
            config.vm.provision "shell", inline: ngrok_cmd
            ngrok_cmd = "echo \"auth_token: " + this_server["ngrok_token"] + "\" >> /home/vagrant/.ngrok; chown vagrant:vagrant /home/vagrant/.ngrok"
            config.vm.provision "shell", inline: ngrok_cmd
        end
    end

    # Timezone
    local_config["servers"].each do |tsk, this_server|
        if this_server["timezone"]
            timezone_cmd = "mv /etc/localtime /etc/localtime.bak; ln -sf /usr/share/zoneinfo/" + this_server["timezone"] + " /etc/localtime"
            config.vm.provision "shell", inline: timezone_cmd
        end
    end

    local_config["servers"].each do |tsk, this_server|
        hostname_cmd = "echo \"" + this_server["guest_ip"] + " " + this_server["guest_hostname"] + "\" >> /etc/hosts"
        config.vm.provision "shell", inline: hostname_cmd
    end

    if local_config.has_key?("hosts")
        local_config["hosts"].each do |this_host, this_ip|
            hostname_cmd = "echo \"" + this_ip + " " + this_host + "\" >> /etc/hosts"
            config.vm.provision "shell", inline: hostname_cmd
        end
    end

    # Box-specific
    if server.has_key?("scripts")
        server["scripts"].each do |script, key|
            serverScript = "/vagrant/scripts/" + script + " 2&>1 >> /vagrant/provision.log"
            instance.vm.provision "shell", inline: serverScript
        end
    end

end
