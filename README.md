# Now Linux Build

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/cemalgnlts/now-linux-build/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/cemalgnlts/now-linux-build/tree/master)

A custom [Buildroot](https://buildroot.org/) config for [Now](https://github.com/cemalgnlts/now).

## Folder Structure
```
+-- board/
    +-- v86
        +-- linux.config        # Our custom Linux kernel config
        +-- rootfs_overlay/     # Overrides for files in the root filesystem
            +-- etc/
                +-- inittab     # We setup a ttyS0 console terminal to root
                +-- fstab       # We auto-mount the Plan 9 Filer filesystem to /root
                +-- profile     # To customize our individual work environment
            +-- opt/
                +--- now/       # Special files for Now
    +-- configs/
        +-- now_defconfig       # Our custom buildroot config
    +-- Config.in               # empty, but required https://buildroot.org/downloads/manual/manual.html#outside-br-custom
    +-- external.mk             # empty, but required https://buildroot.org/downloads/manual/manual.html#outside-br-custom
    +-- external.desc           # our board config for make
    +-- build.sh                # entrypoint for build
```