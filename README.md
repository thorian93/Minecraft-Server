# Minecraft Server

This repository contains my very own Minecraft server including deployment magic.

## Ressources

- https://minecraft.gamepedia.com/Tutorials/Setting_up_a_server

## How To

The startup is pretty simple:

1. Clone the repository
2. Navigate into the `control` directory

    `cd ./control/`

3. Bootstrap the server:

    `./control.sh -m bootstrap -t $HCLOUD_TOKEN`

4. Navigate into the `ansible` directory

    `cd ../ansible/`

5. Copy `inventory/group_vars/minecraft_hosts/personal.yml.template` to `inventory/group_vars/minecraft_hosts/personal.yml` and configure your settings

    `cp inventory/group_vars/minecraft_hosts/personal.yml.template inventory/group_vars/minecraft_hosts/personal.yml`

5. Start the server:

    `ansible-playbook -i inventory/hcloud.py playbooks/main.yml --tags full`

6. Log in using your Minecraft client.

## Disclaimer

Minecraft is a trademark of Mojang Synergies AB, a subsidiary of Microsoft Studios. These tools are designed to ease the use of the Mojang produced Minecraft server software on Linux servers. The tools are independently developed by me with no support or implied warranty provided by either Mojang or Microsoft.

## Author Information

The server config was created in 2021 by [Thorian93](http://thorian93.de/).
