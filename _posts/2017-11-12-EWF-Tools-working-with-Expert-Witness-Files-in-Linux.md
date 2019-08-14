---
layout: posts
title: "EWF Tools: working with Expert Witness Files in Linux"
date: '2017-11-12T21:42:22+09:00'
author: Joshua
tags:
- infosec
- dfir
- Disk Acquisition
modified_time: '2017-11-12T21:42:22+09:00'
---

Expert Witness Format (EWF) files, often saved with an E01 extension, are very common in digital investigations.
Many forensic tools support E01 files, but many non-forensic tools don't. This is a problem if you are using
other tools, like many Linux utilities to try to do an investigation.

Enter [Libewf](http://www.forensicswiki.org/wiki/Libewf). Libewf is an open source library that supports
reading and writing EWF formats. Using libewf and ewf-tools, we can easily create and access EWF files in Linux and OSx.

## Installing from APT
In Ubuntu, libewf tools can be found in the package *libewf-dev* and *libewf2*. The tools themselves can be found in the package *ewf-tools*. To install, run the following:

```
sudo apt install libewf-dev ewf-tools
```
## Installing from source
To install libewf from source, including associated tools, we need to clone the [repository](https://github.com/libyal/libewf/), and compile.

First we need to clone the code repository, and change permissions so we can compile.
```
cd /opt
sudo git clone https://github.com/libyal/libewf.git
sudo chown -R *username* libewf
cd libewf
```

Next we need to get required libraries and compile.
```
sudo apt install autoconf automake autopoint libtool pkg-config
./synclibs.sh
./autogen.sh
./configure
make -j8
sudo make install
```

## Acquiring a disk image
Now that the tools are installed, attach the target disk with a [disk writer](https://www.youtube.com/edit?o=U&video_id=7eT8KSHMGFw). Find the target disk using *lsblk*.
Let's say the target disk is /dev/sdc. Choose where you will save the target disk image (the destination).
Our destination will be /Cases/001/. EWF supports compression, but make sure you will have enough space
in the destination.

We will use ewfacquire to acquire the disk image. The *-t* switch allows us to give the destination. We need to
provide the disk image name without an extension. In this example I will use *001_2017_USB_Gold*.

```
sudo ewfacquire -t /Cases/001/001_2017_USB_Gold /dev/sdc
```
Any arguments that you did not add in the command line, you will have to answer through additional questions. The value I change the most is the segment file size *-S* to *-S 4G*. You can also use the *-u* flag for unattended mode. In that case, all arguments would need to be set at the command line.

Once the disk has been acquired, check it with *ewfinfo* and *ewfverify*.
```
ewfinfo /Cases/001/001_2017_USB_Gold.E01
ewfverify /Cases/001/001_2017_USB_Gold.E01
```
Check out this video on creating a EWF disk image.
{% include video id="4D5XZ0AK9ak" provider="youtube" %}

## Mount EWF
Next, you may want to mount the disk image to provide direct access to the copied disk. After mounting,
tools that do not support EWF can get access to the disk or mounted partitions. In this example, we will
mount the EWF image, which will provide access to a device that looks like a physical disk. If you want
to mount any partitions, you will have to find the offsets.

To mount the EWF we will use *ewfmount*. First we need to create a mount point.
```
sudo mkdir /mnt/ewf
sudo chown *username* /mnt/ewf
ewfmount /Cases/001/001_2017_USB_Gold.E01 /mnt/ewf
cd /mnt/ewf
```

Now the device inside /mnt/ewf is the physical disk image - or logical disk image depending on which source image you made - and
you can access the device with any other tools.

Check out this video on mounting an EWF disk image.
{% include video id="3S-joLMbDGo" provider="youtube" %}
