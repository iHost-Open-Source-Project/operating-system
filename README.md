# linux-distro
## Prepare
if you want to compile the linux-distro, Please complete the following steps:
1. move you uboot to ${HOME} directory.
2. add the following to the buildroot/boot/uboot/Config.in
```
choice
    prompt "U-Boot Version"
    help
      Select the specific U-Boot version you want to use
......

config BR2_TARGET_UBOOT_CUSTOM_LOCAL
   bool "Custom local repository"
endchoice
```
```
config BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION
    string "URL of custom U-Boot tarball"
    depends on BR2_TARGET_UBOOT_CUSTOM_TARBALL
config BR2_TARGET_UBOOT_CUSTOM_LOCAL_LOCATION
    string "Path of custom U-Boot local repository"
    depends on BR2_TARGET_UBOOT_CUSTOM_LOCAL
```
1. add the following to the buildroot/boot/uboot/uboot.mk after 27 line
```
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_LOCAL),y)
UBOOT_SITE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_LOCAL_LOCATION))
UBOOT_SITE_METHOD = local
``` 
## Build

```bash
make BR2_EXTERNAL=./buildroot-external/ O=output/linux-distro linux_distro
```
