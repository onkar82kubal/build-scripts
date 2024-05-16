#!/bin/bash -e
# -----------------------------------------------------------------------------
#
# Package           : ordereddict
# Version           : 0.4.15
# Source repo       : https://github.com/ruamel/ordereddict
# Tested on         : UBI:9.3
# Language          : Python
# Travis-Check      : True
# Script License    : Apache License, Version 2 or later
# Maintainer        : Vinod K <Vinod.K1@ibm.com>
#
# Disclaimer        : This script has been tested in root mode on given
# ==========          platform using the mentioned version of the package.
#                     It may not work as expected with newer versions of the
#                     package and/or distribution. In such case, please
#                     contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
PACKAGE_NAME=ordereddict
PACKAGE_VERSION=${1:-0.4.15}
PACKAGE_URL=https://github.com/ruamel/ordereddict
HOME_DIR=`pwd`

yum -y update && yum install -y git gcc gcc-c++ make zlib zlib-devel unzip
curl -v -O https://rpmfind.net/linux/centos-stream/9-stream/AppStream/ppc64le/os/Packages/redhat-rpm-config-206-1.el9.noarch.rpm -L 
yum localinstall redhat-rpm-config-206-1.el9.noarch.rpm -y

curl -v -O https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz -L
tar xzvf Python-2.7.18.tgz
cd Python-2.7.18
./configure && make && make altinstall
cd /usr/local/bin
ln -s python2.7 python
cd $HOME_DIR
curl -v -O https://bootstrap.pypa.io/pip/2.7/get-pip.py -L
python -m ensurepip --default-pip

if ! git clone $PACKAGE_URL $PACKAGE_NAME; then
    	echo "------------------$PACKAGE_NAME:clone_fails---------------------------------------"
		echo "$PACKAGE_URL $PACKAGE_NAME"
		echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Clone_Fails"
    	exit 0
fi
cd $PACKAGE_NAME
# pip install setuptools==19.2.3
git checkout $PACKAGE_VERSION
if ! python setup.py install; then
    echo "------------------$PACKAGE_NAME:install_fails---------------------------------------"
	echo "$PACKAGE_URL $PACKAGE_NAME"
	echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Install_Fails"
	exit 0
fi
if ! python ./test/testordereddict.py; then
	echo "------------------$PACKAGE_NAME:install_success_but_test_fails---------------------"
	echo  "$PACKAGE_URL $PACKAGE_NAME " 
	echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Install_success_but_test_Fails"
	exit 0
else
	echo "------------------$PACKAGE_NAME:install_and_test_both_success-------------------------"
	echo  "$PACKAGE_URL $PACKAGE_NAME " 
	echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | $SOURCE  | Pass |  Both_Install_and_Test_Success"
	exit 0
fi