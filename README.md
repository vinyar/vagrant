Getting Started
========

This file contains instructions on how to setup and manage your own instance of Vagrant.
For additional information, see:

	http://www.vagrantup.com/

Download & Install VirtualBox

	https://www.virtualbox.org/wiki/Downloads

Download & Install Vagrant

	http://downloads.vagrantup.com/

Download & Boot the Server

	Open a terminal. CD into the "vagrant" directory (the directory that contains this
	file) and run the following command:

	$ vagrant box add precise64 http://files.vagrantup.com/precise64.box

	Boot up an instance of the server by running the following command:

	$ vagrant up

You can SSH into your Vagrant instance by running:

	$ vagrant ssh

Additional Notes
========

When you are done working with your server instance, you should shut it down by running
the following command:

	$ vagrant suspend

You can bring it back up again at any time by running:

	$ vagrant up

In the event of a serious error, you may be required to completely destroy your instance
of the server and rebuild it. To do that, run:

	$ vagrant destroy
	$ vagrant up
