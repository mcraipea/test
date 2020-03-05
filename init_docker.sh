#!/usr/bin/env bash

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=`whoami`

################################################################################

# Config
docker_destination="/goinfre/$USER/docker" #=> Select docker destination (goinfre is a good choice)

################################################################################

# Colors
blue=$'\033[0;34m'
cyan=$'\033[1;96m'
reset=$'\033[0;39m'


function rm_and_link() {
	rm -rf ~/Library/Containers/com.docker.docker ~/.docker
	mkdir -p $docker_destination/{com.docker.docker,.docker}
	ln -sf $docker_destination/com.docker.docker ~/Library/Containers/com.docker.docker
	ln -sf $docker_destination/.docker ~/.docker
}

# Kill Docker if started
pkill Docker

# Create needed files in destination and make symlinks
if [ -d $docker_destination ]; then
	read -n1 -p "${blue}Folder ${cyan}$docker_destination${blue} already exists, do you want to reset it? [y/${cyan}N${blue}]${reset} " input
	echo ""
	if [ -n "$input" ] && [ "$input" = "y" ]; then
		rm_and_link
	fi
else
	rm_and_link
fi

# Start Docker for Mac
open -g -a Docker
echo -e "${cyan}Docker${blue} is now starting!${reset}"
