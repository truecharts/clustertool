# Clustertool

Easy deployment tooling and documentation for deploying TalosOS and/or FluxCD

## Limitations

Our default talconfig.yaml file, makes a lot of assumptions for quick deployment. You're free to adapt your version of it as you please.
By default you:

- Should not have more than 1 network adapter on controlplane nodes
- Should not have more than 1 Disk on controlplane nodes

## Requirements

### All-in-One VM

Our default configuration ships with qemu guest additions installed already.

#### Minimum Specs

6 Threads or vCores
8GB Ram
128GB storage
1GBe Networking

#### Recommended specs

8 Cores
16GB Ram
256GB storage
10GBe Networking

## TalosOS synopsys

TalosOS is a bare-bones linux distribution to run kubernetes clusters.
It gets build/installed/maintained based on configuration files.

To more-easily generate those, we use another tool internally: talhelper.
When using clustertool, configuration mangement goes like this:

clustertool -> talhelper -> talosctl -> node/vm

---

## Getting Started

### Setting up requirements

#### windows

Please run this in a WSL Linux (Preferably Debian) shell instead of directly on windows.
DO NOT use a GIT folder checked-out on windows, on the WSL. Ensure you git-clone or git-checkout the folder on WSL when using it in WSL!

#### Linux

**Required External Dependencies**

- curl
- GIT
- Bash
- Python3
- PIP3

**Other Dependencies**

- Ensure your local system time is 100% correct
- Run `sudo ./clustertool.sh` tool to install the other dependencies automatically


## Preparations

- Fork the repo here, to your own github account or download and extract
- Ensure you've cd'ed into this folder.
- edit `talenv.yaml` and set the settings as you want them
- Be sure to set `VIP` to a seperate free IP adress from MASTER1, MASTER1 being your nodeIP adresss VIP being used by the system internally.
- Also make sure to give `METALLB_RANGE`, a free IP range *outside* of your router DHCP range
- The `KUBEAPPS_IP`, will be used to expose KubeApps, for giving you an easy Apps management GUI
- Set static DHCP adresses on your router to the IP adresses you defined in `talenv.yaml`

## ISO prep

We use pre-extended builds of TalosOS with additional drivers.
For ISO's we advice to use the following:

**Iso for VM installation**

AMD64 ISO: https://factory.talos.dev/image/dc2c29fc8374161b858245a14658779154bf11aa9c23a04813fa8f298fcd0bfc/v1.6.4/metal-amd64.iso



## Bootstrapping TalosOS on the cluster

- Run `sudo ./clustertool.sh` tool, generate cluster configuration
- Boot the VM with able iso
- Ensure the VM has the IP adresses defined earlier and the same VM is set in `talenv.yaml`
- Run `sudo ./clustertool.sh` tool, Apply and Bootstrap the TalosOS cluster
- *optional* Run `sudo ./clustertool.sh` tool, Encrypt your configuration files
- **IMPORTANT**: safe the content of the folder**safe**, this contains the encryption key to your cluster!
- After waiting a few minutes, you will now have KubeApps available on http://KUBEAPPS_IP:80 where `KUBEAPPS_IP` is the IP intered above.
