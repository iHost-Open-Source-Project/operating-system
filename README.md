# linux-distro
Linux Distro is an OS based on buildroot compilation, designed to make it easier for you to use a simple Linux operating system on ihost.

## Build
We recommend running your required Docker containers on iHost Linux Distro to verify your assumptions. However, if you want to try customizing your own iHost Linux Distro, please refer to the [buildroot user manual](https://buildroot.org/downloads/manual/manual.html) and follow these instructions for compilation:
```bash
make O=output/ihost ihost
```

## Usage
You can find the IP address with hostname "buildroot" in your router's backend, then login via SSH using:
- Username: root
- Password: root
