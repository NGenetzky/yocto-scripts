#!/bin/bash

set -eu -o pipefail

# repo init -u git://github.com/Xilinx/yocto-manifests.git -b rel-v2020.1
# repo sync

MACHINE='qemu-zynq7'

builddir="build-${MACHINE}"
mkdir -p "${builddir}"
ln -sfT "${builddir}" "build"
mkdir -p "${builddir}/conf/"

# https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841671/Using+meta-xilinx-tools+layer
cat <<- EOF > "${builddir}/conf/auto.conf"
#USE_XSCT_TARBALL='0'
#XILINX_VER_MAIN='2020.1'
#XILINX_SDK_TOOLCHAIN='/opt/Xilinx/Vitis/2020.1/bin/xsct'

#BB_FETCH_PREMIRRORONLY = "1"
#SSTATE_MIRROR_ALLOW_NETWORK = "1"

#DL_DIR = "\${TOPDIR}/../downloads/"
#SSTATE_DIR = "\${TOPDIR}/../sstate-cache/"
EOF

# cat <<- EOF > "${builddir}/conf/site.conf"
# SSTATE_MIRRORS = "\
# file://.* file:///workspace/dojofive/devo-minized-can/petalinux/projects/cache/sstate_2020.1/arm/PATH \n \
# file://.* file:///workspace/dojofive/devo-minized/petalinux/projects/minized_minimal_2020_1/build/sstate-cache/PATH \n \
# file://.* file:///mnt/virt-host//yocto/sstate-cache/PATH \n \
# "

# PREMIRRORS_prepend = "\
# git://.*/.* file:///workspace/dojofive/devo-minized-can/petalinux/projects/cache/downloads_2020.1/downloads/ \n \
# ftp://.*/.* file:///workspace/dojofive/devo-minized-can/petalinux/projects/cache/downloads_2020.1/downloads/ \n \
# http://.*/.* file:///workspace/dojofive/devo-minized-can/petalinux/projects/cache/downloads_2020.1/downloads/ \n \
# https://.*/.* file:///workspace/dojofive/devo-minized-can/petalinux/projects/cache/downloads_2020.1/downloads/ \n \
# "
# EOF

# Required for oe-init-build-env
# set +u
# source setupsdk
# export MACHINE
# bitbake virtual/fsbl


kas-docker build kas/kas-xilinx-rel-v2020.1.yml --target "virtual/fsbl"
kas-docker build kas/kas-xilinx-rel-v2020.1.yml --target "virtual/device-tree"
kas-docker build kas/kas-xilinx-rel-v2020.1.yml --target "core-image-base"

################################################################################
exit 0
################################################################################

