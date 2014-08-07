def configDigitalOcean(instance, server, local_config, config)

    instance.cache.auto_detect = true;

    instance.vm.box = "digital_ocean"

    instance.vm.provider :digital_ocean do |provider, override|
        override.vm.box = "digital_ocean"
        override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
        override.ssh.private_key_path = local_config["private_key_path"]
        provider.token = server["provider_settings"]["token"]
        provider.image = server["provider_settings"]["image"]
        provider.region = server["provider_settings"]["region"]
        provider.size = server["provider_settings"]["size"]
        provider.ssh_key_name = server["provider_settings"]["ssh_key_name"]
    end

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

    # Guest provisioning

    # Timezone
    local_config["servers"].each do |this_server, tsk|
        if this_server["timezone"]
            timezone_cmd = "mv /etc/localtime /etc/localtime.bak; ln -sf /usr/share/zoneinfo/" + this_server["timezone"] + " /etc/localtime"
            config.vm.provision "shell", inline: timezone_cmd
        end
    end

    if local_config.has_key?("hosts")
        local_config["hosts"].each do |this_server, tsk|
            hostname_cmd = "echo \"" + this_server["ip"] + " " + this_server["host"] + "\" >> /etc/hosts"
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
