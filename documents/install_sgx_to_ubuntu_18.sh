# Ubuntu 18.04.2 LTS (GNU/Linux 4.15.0-29-generic x86_64)
# https://github.com/intel/linux-sgx-driver
# https://github.com/intel/linux-sgx


# Setup working directory
wdir="~/sgx"
mkdir -p $wdir


# Installing SGX on Ubuntu 18.04
# Update and upgrade apt-get
cd $wdir
sudo apt-get update
sudo apt-get upgrade

# Installing SGX driver
# ------------------------------
git clone https://github.com/intel/linux-sgx-driver.git

# To check if matching kernel headers are installed
dpkg-query -s linux-headers-$(uname -r)

# To install matching headers
sudo apt-get install linux-headers-$(uname -r)

# Install build commands and make driver
sudo apt-get install make gcc gdb
cd $wdir/linux-sgx-driver
make

# To install the Intel(R) SGX driver, enter the following command with root privilege
sudo mkdir -p "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"
sudo cp isgx.ko "/lib/modules/"`uname -r`"/kernel/drivers/intel/sgx"
sudo sh -c "cat /etc/modules | grep -Fxq isgx || echo isgx >> /etc/modules"
sudo /sbin/depmod
sudo /sbin/modprobe isgx



# Installing SGX SDK and PSW
# ------------------------------
cd $wdir
git clone https://github.com/intel/linux-sgx.git

# Use the following command(s) to install the required tools to build the Intel(R) SGX SDK
sudo apt-get install build-essential ocaml ocamlbuild automake autoconf libtool wget python libssl-dev
sudo apt-get install libssl-dev libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper

# Use the script download_prebuilt.sh inside source code package to download prebuilt binaries to prebuilt folder
cd $wdir/linux-sgx
./download_prebuilt.sh

# To build both Intel(R) SGX SDK and PSW with default configuration, enter the following command
make

# To build the Intel(R) SGX SDK installer, enter the following command
sudo apt-get install libprotobuf-dev protobuf-compiler libcurl4-openssl-dev
make sdk_install_pkg

# To build the Intel(R) SGX PSW installer, enter the following command
make deb_pkg

# To install the Intel(R) SGX SDK, invoke the installer, as follows
cd linux/installer/bin
./sgx_linux_x64_sdk_${version}.bin
source /home/vagrant/sgx/linux-sgx/linux/installer/bin/sgxsdk/environment

# make SGX_MODE=SIM

# TODO: Install the Intel(R) SGX PSW
