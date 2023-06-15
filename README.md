# Now Linux Build

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/cemalgnlts/now-linux-build/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/cemalgnlts/now-linux-build/tree/master)

A custom [Buildroot](https://buildroot.org/) config for [Now](https://github.com/cemalgnlts/now).

## Folder Structure
```
+-- board/
    +-- now
        +-- linux.config        # Our custom Linux kernel config
        +-- rootfs_overlay/     # Overrides for files in the root filesystem
            +-- root/           # User home folder
            +-- etc/
                +-- inittab     # We setup a ttyS0 console terminal to root
                +-- fstab       # We auto-mount the Plan 9 Filer filesystem to /root
                +-- profile     # To customize our individual work environment
            +-- opt/
                +--- now/       # Special files for Now
            +-- usr/
                +-- local/
                    +-- lib/    # For 3rd party libraries (nodejs)
    +-- configs/
        +-- now_defconfig       # Our custom buildroot config
    +-- Config.in               # empty, but required https://buildroot.org/downloads/manual/manual.html#outside-br-custom
    +-- external.mk             # empty, but required https://buildroot.org/downloads/manual/manual.html#outside-br-custom
    +-- external.desc           # our board config for make
    +-- build.sh                # entrypoint for build
```

## Credits
It was created using these sources:
- [humphd/browser-vm](https://github.com/humphd/browser-vm).
- [SkiffOS/v86](https://github.com/skiffos/SkiffOS/blob/master/configs/browser/v86).
- [v86/copy](https://github.com/copy/v86/issues/725#issuecomment-1307807275).

## License
Buildroot itself is an open source software, released under the GNU General Public License, version 2 or (at your option) any later version, with the exception of the package patches detailed below.

See also the [Buildroot license notice](https://buildroot.org/downloads/manual/manual.html#legal-info-buildroot) for more nuances about the meaning of this license.