# Minecraft Server

This repository contains my very own Minecraft server including deployment magic.

## Ressources

- https://minecraft.gamepedia.com/Tutorials/Setting_up_a_server

## How To

The startup is pretty simple:

1. Clone the repository
2. Navigate into the `control` directory
3. Run `./control.sh -m bootstrap -t $HCLOUD_TOKEN` to bootstrap the server
4. Navigate into the `ansible` directory
5. Run `ansible-playbook -i inventory/hcloud.py playbooks/main.yml --tags full` to startup the server
6. Log in

## Author Information

The server config was created in 2021 by [Thorian93](http://thorian93.de/).
