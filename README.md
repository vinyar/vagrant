# Getting Started

This file contains instructions on how to setup and manage your own [Vagrant instance](http://vagrantup.com).

## Install Core Software

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Install [Vagrant](http://downloads.vagrantup.com/)

## Install Vagrant Plugins

```
$ vagrant plugin install vagrant-cachier
$ vagrant plugin install vagrant-hostsupdater
$ vagrant plugin install vagrant-digitalocean
```

## Creating Your First Server

Run the following command:

```
$ vagrant up
```

This will create a simple, default box based off the configuration settings in `config.default.json`. You can completely replace this file with your own settings, or you can selectively overwrite specific settings by creating a separate config file at `config.json`.

## Connecting via SSH

```
$ vagrant ssh
```

## Suspending the Server

```
$ vagrant suspend
```

## Halting the Server

```
$ vagrant halt
```

## Destroying the Server

```
$ vagrant destroy
```

## Configuration Examples

See [./configuration-examples](configuration-examples). These should be used to replace `config.default.json` and `config.json`.