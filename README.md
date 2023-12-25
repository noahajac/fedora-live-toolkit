# Fedora Live Toolkit

Collection of scripts and configurations to create a a bootable [Fedora Linux 38](https://fedoraproject.org) "toolkit" flash drive.

* Google Chrome, chntpw, and gparted are preinstalled onto the live image.
* Supports booting on UEFI and BIOS.
* Takes up less than 4GB. The remaining space on the drive is partitioned for regular data usage.

This has been made for my own personal use, so it may have some oddly specific design choices. Disk and partition IDs are hardcoded, so be wary of creating multiple USBs.

## Building

The following steps have only been run on Fedora Linux 38. I am unsure if they will run on other versions or distributions.

1. Install the necessary dependencies via your package manager: `mock`
2. Clone this repository.
3. Run the `./build-files` script as root.
    * Mock will create a chroot build environment, root is needed to run some of the necessary commands.

## Installation to Drive

1. Edit line 3 of `./flash-drive` to point to the block device path.
    * The drive being used should be at least 4GB.
    * The script expects `/dev/disk/by-id/<ID>` ID paths. Paths such as `/dev/sda` will not work without modifying the script.
2. Edit `./Read If Found.txt`. This is simply a README file that will be copied to the data partition. You can remove it if you don't want this.
3. Run `./flash-drive` as root and follow the prompts.

## Licenses

Fedora Linux is licensed under [the MIT license](https://docs.fedoraproject.org/en-US/legal/fedora-linux-license). The packages includes in Fedora, or installed with these scripts, are licensed separately.
