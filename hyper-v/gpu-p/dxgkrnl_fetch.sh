#!/usr/bin/bash

array=(drivers/hv/Makefile
drivers/hv/dxgkrnl/dxgadapter.c
drivers/hv/dxgkrnl/dxgkrnl.h
drivers/hv/dxgkrnl/dxgmodule.c
drivers/hv/dxgkrnl/dxgprocess.c
drivers/hv/dxgkrnl/dxgsyncfile.c
drivers/hv/dxgkrnl/dxgsyncfile.h
drivers/hv/dxgkrnl/dxgvmbus.c
drivers/hv/dxgkrnl/dxgvmbus.h
drivers/hv/dxgkrnl/hmgr.c
drivers/hv/dxgkrnl/hmgr.h
drivers/hv/dxgkrnl/ioctl.c
drivers/hv/dxgkrnl/Kconfig
drivers/hv/dxgkrnl/Makefile
drivers/hv/dxgkrnl/misc.c
drivers/hv/dxgkrnl/misc.h
include/uapi/misc/d3dkmthk.h)

WORKDIR=~/linux-5.15.0
cd $WORKDIR

mkdir -p ./drivers/hv/dxgkrnl

for object in ${array[@]}; do
  wget "https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.15.90.1/$object" --output-document="./$object"
done