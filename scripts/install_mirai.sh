#!/bin/bash
# MiraintTool v.1.0
#Date: 24/03/2017
#Written by: Tsutomu | glibc
#NOTE* "chmod 777 setup.sh" "./setup.sh"

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Update
read -r -p $'\e[93mShall we start by updating your box? (y/N)\e[0m: ' update
if [[ $update =~ ^([yY][eE][sS]|[yY])$ ]]; then
	apt-get update -y && apt-get upgrade -y && apt-get install build-essential -y
	clear
else
	printf "Script continuing...\n"
	sleep 3
	clear
fi

# Install/Setup MySQL + Golang
read -r -p $'\e[93mWould you like to install/setup MySQL + Golang?.. (y/N)\e[0m: ' setup
if [[ $setup =~ ^([yY][eE][sS]|[yY])$ ]]; then
	apt-get install mysql-server mysql-client gcc curl electric-fence git -y
	cd /tmp; curl -O https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz
	tar xvf go1.7.4.linux-amd64.tar.gz
	rm -rf go1.7.4.linux-amd64.tar.gz
	chown -R root:root ./go; mv go /usr/local
	source .bashrc
	clear
else
	printf "Script continuing...\n"
	sleep 3
	clear
fi

# Download/Extract Cross Compiler Tool-Chains
read -r -p $'\e[93mWould you like to install/uncompile all cross compiler tool-chains? (y/N)\e[0m: ' install
if [[ $install =~ ^([yY][eE][sS]|[yY])$ ]]; then
	mkdir /etc/xcompile >/dev/null; cd /etc/xcompile
	printf "\e[93mPlease wait...\e[97m\n"
	if [ -d cross-compiler-armv4l ]; then
		echo -e "cross-compiler-armv4l is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-armv4l.tar.bz2
		tar -xvjf cross-compiler-armv4l.tar.bz2; clear
		mv cross-compiler-armv4l armv4l
	fi
	if [ -d cross-compiler-armv5l ]; then
		echo -e "cross-compiler-armv5l is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-armv5l.tar.bz2
		tar -xvjf cross-compiler-armv5l.tar.bz2; clear
		mv cross-compiler-armv5l armv5l
	fi
	if [ -d cross-compiler-armv6l ]; then
		echo -e "cross-compiler-armv6l is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-armv6l.tar.bz2
		tar -xvjf cross-compiler-armv6l.tar.bz2; clear
		mv cross-compiler-armv6l armv6l
	fi
	if [ -d cross-compiler-mips ]; then
		echo -e "cross-compiler-mips is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-mips.tar.bz2
		tar -xvjf cross-compiler-mips.tar.bz2; clear
		mv cross-compiler-mips mips
	fi
	if [ -d cross-compiler-mipsel ]; then
		echo -e "cross-compiler-mipsel is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-mipsel.tar.bz2
		tar -xvjf cross-compiler-mipsel.tar.bz2; clear
		mv cross-compiler-mipsel mipsel
	fi
	if [ -d cross-compiler-sparc ]; then
		echo -e "cross-compiler-sparc is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-sparc.tar.bz2
		tar -xvjf cross-compiler-sparc.tar.bz2; clear
		mv cross-compiler-sparc sparc
	fi
	if [ -d cross-compiler-powerpc ]; then
		echo -e "cross-compiler-powerpc is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-powerpc.tar.bz2
		tar -xvjf cross-compiler-powerpc.tar.bz2; clear
		mv cross-compiler-powerpc powerpc
	fi
	if [ -d cross-compiler-i686 ]; then
		echo -e "cross-compiler-i686 is present"
	else
		wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-i686.tar.bz2
		tar -xvjf cross-compiler-i686.tar.bz2; clear
		mv cross-compiler-i686 i686
	fi
	if [ -d cross-compiler-sh4 ]; then
		echo -e "cross-compiler-sh4 is present"
	else
		wget http://distro.ibiblio.org/slitaz/sources/packages/c/cross-compiler-sh4.tar.bz2
		tar -xvjf cross-compiler-sh4.tar.bz2; clear
		mv cross-compiler-sh4 sh4
	fi
	if [ -d cross-compiler-m68k ]; then
		echo -e "cross-compiler-m68k is present"
	else
		wget https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-m68k.tar.bz2
		tar -xvjf cross-compiler-m68k.tar.bz2; clear
		mv cross-compiler-m68k m68k
		rm -rf *.bz2
		cd ~/
	fi
	clear
else
	printf "Script continuing...\n"
	sleep 3
	clear
fi

# Webserver & TFTP
read -r -p $'\e[93mWould you like to install webserver and tftp server? (y/N)\e[0m: ' webtftp
if [[ $setup =~ ^([yY][eE][sS]|[yY])$ ]]; then
	apt-get install nginx -y; service nginx restart
	apt-get install tftp tftpd-hpa -y
	cat > /etc/default/tftpd-hpa <<- TFTP
		# /etc/default/tftpd-hpa
		RUN_DAEMON="yes"
		TFTP_OPTIONS="--secure --create --listen --verbose /srv/tftp"
		TFTP_USERNAME="tftp"
		TFTP_ADDRESS="0.0.0.0:69"
	TFTP
	service tftp-hpa restart; clear
	printf "TFTP Server Succesfully Installed!\n"
else
	printf "Script continuing...\n"
	sleep 3
	clear
fi

# .bashrc
read -r -p $'\e[93mWould you like to update your .bashrc?.. (y/N)\e[0m: ' setup
if [[ $setup =~ ^([yY][eE][sS]|[yY])$ ]]; then
	cat >> ~/.bashrc <<- BASHRC
	#Unlimiting File Descriptors
	ulimit -n 999999
	ulimit -u 999999
	ulimit -s 999999
	sysctl -w fs.file-max=100000 >/dev/null
	
	# Cross Compiler Tool-chains
	export PATH=$PATH:/etc/xcompile/armv4l/bin
	export PATH=$PATH:/etc/xcompile/armv5l/bin
	export PATH=$PATH:/etc/xcompile/armv6l/bin
	export PATH=$PATH:/etc/xcompile/i686/bin
	export PATH=$PATH:/etc/xcompile/m68k/bin
	export PATH=$PATH:/etc/xcompile/mips/bin
	export PATH=$PATH:/etc/xcompile/mipsel/bin
	export PATH=$PATH:/etc/xcompile/powerpc/bin
	export PATH=$PATH:/etc/xcompile/sh4/bin
	export PATH=$PATH:/etc/xcompile/sparc/bin

	# Golang
	export PATH=$PATH:/usr/local/go/bin
	export GOPATH=$HOME/Documents/go
	BASHRC
	source ~/.bashrc
	clear
else
	printf "Script continuing...\n"
	sleep 3
	clear
fi

# Install Goland MySQL & Shellwords
read -r -p $'\e[93mWould you like to install/setup MySQL + Shellwords Go Drivers?.. (y/N)\e[0m: ' goshell
if [[ $goshell =~ ^([yY][eE][sS]|[yY])$ ]]; then
	go get github.com/mattn/go-shellwords
	go get github.com/go-sql-driver/mysql
	clear
else
	printf "Script continuing...\n"
	sleep 3
	clear
fi