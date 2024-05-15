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

curl -v -O https://files.pythonhosted.org/packages/b2/40/4e00501c204b457f10fe410da0c97537214b2265247bc9a5bc6edd55b9e4/setuptools-44.1.1.zip  -L
unzip setuptools-44.1.1.zip
cd setuptools-44.1.1
python bootstrap.py

mkdir wheels
cd wheels
curl -v -O https://files.pythonhosted.org/packages/53/7f/55721ad0501a9076dbc354cc8c63ffc2d6f1ef360f49ad0fbcce19d68538/pip-20.3.4.tar.gz  -L
tar xzvf pip-20.3.4.tar.gz
cd $HOME_DIR
python ./wheels/pip-20.3.4-py2.py3-none-any.whl/pip install --no-index --find-links ./wheels/ pip --ignore-installed

# python ./setuptools-44.1.1/setup.py install


if ! git clone $PACKAGE_URL $PACKAGE_NAME; then
    	echo "------------------$PACKAGE_NAME:clone_fails---------------------------------------"
		echo "$PACKAGE_URL $PACKAGE_NAME"
		echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Clone_Fails"
    	exit 0
fi
cd $PACKAGE_NAME
# pip install setuptools==40.0.0
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

# yum -y update && yum install -y git gcc gcc-c++ make redhat-rpm-config 
# # python-devel
# curl -v -O https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz -L
# tar xzvf Python-2.7.18.tgz
# cd Python-2.7.18
# ./configure && make && make altinstall
# cd /usr/local/bin
# ln -s python2.7 python
# cd $HOME_DIR
# yum install pip -y
# # pip install virtualenv
# which python

# OS_NAME=$(cat /etc/os-release | grep ^PRETTY_NAME | cut -d= -f2)
# echo $OS_NAME

# if ! git clone $PACKAGE_URL $PACKAGE_NAME; then
#     	echo "------------------$PACKAGE_NAME:clone_fails---------------------------------------"
# 		echo "$PACKAGE_URL $PACKAGE_NAME"
# 		echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Clone_Fails"
#     	exit 0
# fi

# cd $PACKAGE_NAME
# # virtualenv -p /usr/local/bin/python isoEnv
# # pip install setuptools==44.0.0
# pip install setuptools==2.0
# pip install mercurial==5.2
# git checkout $PACKAGE_VERSION
# if ! python setup.py install; then
#     echo "------------------$PACKAGE_NAME:install_fails---------------------------------------"
# 	echo "$PACKAGE_URL $PACKAGE_NAME"
# 	echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Install_Fails"
# 	exit 0
# fi

# cd $PACKAGE_NAME
# if ! python test/testordereddict.py; then
# 	echo "------------------$PACKAGE_NAME:install_success_but_test_fails---------------------"
# 	echo  "$PACKAGE_URL $PACKAGE_NAME " 
# 	echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Install_success_but_test_Fails"
# 	exit 0
# else
# 	echo "------------------$PACKAGE_NAME:install_and_test_both_success-------------------------"
# 	echo  "$PACKAGE_URL $PACKAGE_NAME " 
# 	echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | $SOURCE  | Pass |  Both_Install_and_Test_Success"
# 	exit 0
# fi