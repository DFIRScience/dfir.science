---
layout: posts
title: "Imaging Android with ADB, Root, Netcat and DD"
date: '2017-04-21T19:54:44+09:00'
author: Joshua
tags:
- infosec
- dfir
- howto
- mobile acquisition
- android
- linux
modified_time: '2017-04-22T15:55:44+09:00'
---

Today we are going to acquire an android smartphone (Samsung Note II) using Android Debug Bridge (ADB), netcat and dd. The system I am using is Ubuntu linux. On the "forensic workstation" you will need ADB and netcat installed. I'm using the excellent instructions from [here](https://freeandroidforensics.blogspot.kr/2014/08/live-imaging-android-device.html).

Video forensic workstation Linux:
{% include video id="UQYuaOC5v0I" provider="youtube" %}

Video forensic workstation Windows:
{% include video id="KKkvkCgMeMA" provider="youtube" %}

First, download and install ADB from the [android developer website](https://developer.android.com/studio/releases/platform-tools.html#download).

Next, download 2 apk files to your forensic workstation:

 - [KingoRoot](https://root-apk.kingoapp.com/)  <-- tool to root the android phone
 - [BusyBox](http://www.appsapk.com/busybox-app/)  <-- utilities to copy and send data from the phone


**Note:** Android rooting software is sometimes malware or repackaged with malware. Test your rooting software before using it in a case. Also, check local legislation to see if rooting can produce admissible evidence.

Once ADB is installed. Connect the android phone (while it's on). Open a terminal / command line and run:

````
adb devices
````

You should see something like the following:

    List of devices attached
    4300********061	device

If you see the device as 'unauthorized' check the smartphone for any 'allow connections from this computer' warnings.

Next, we need to transfer the two android aps to the device.

````
adb -d install KingoRoot.apk
adb -d install BusyBox.apk
````

Once installed, check the phone. Find the app KinoRoot. Make sure you are connected to the Internet (unfortunately). Click "One click Root", and wait for Kingo to root the phone.

Hopefully rooting was successful. Once finished, open the BusyBox app. Click 'Install' to install the busybox utilities.

Once the phone is rooted and busybox utilities are installed, we can start the acquisition. Back on the forensic workstation, let's connect to the phone:

````
adb -d shell
ls /data
su
ls /data
````

adb -d shell connects to the phone. We use 'ls /data' to test if we have access to a protected directory. The first time you run it, it should fail. Next we use 'su' to switch the user to root. We then use 'ls /data' again to test if we now have access to protected directories.

Next, we need to check the partitions on the device:

````
cat /proc/partitions
````

You will likely get an output like this:

````
shell@t0ltelgt:/ $ cat /proc/partitions
major minor  #blocks  name

 253        0    1048576 vnswap0
 179        0   30535680 mmcblk0
 179        1       4096 mmcblk0p1
 179        2       4096 mmcblk0p2
 179        3      20480 mmcblk0p3
 179        4       4096 mmcblk0p4
 179        5       4096 mmcblk0p5
 179        6       4096 mmcblk0p6
 179        7       8192 mmcblk0p7
 179        8       8192 mmcblk0p8
 179        9       8192 mmcblk0p9
 179       10      90112 mmcblk0p10
 179       11     262144 mmcblk0p11
 179       12    1310720 mmcblk0p12
 179       13    2457600 mmcblk0p13
 179       14     573440 mmcblk0p14
 179       15       8192 mmcblk0p15
 259        0   25759744 mmcblk0p16
````

We are interested in the physical disk. In this case "mmcblk0". We could also use 'blkid' to show the whole path. mmcblk0 is at '/dev/block'.

Next, we need to set out connection routing between the forensic workstation and the phone. We will forward all data from port 8888 between the phone and the workstation. On the forensic workstation run:

````
adb forward tcp:8888 tcp:8888
````

On the mobile device read the physical disk and send the data over the network (port 8888). Here we are using netcat (nc) to listen for a connection on port 8888.

````
dd if=/dev/block/mmcblk0 | busybox nc -l -p 8888
````

Now that the phone is listening for a connection, we use the forensic workstation to connect. After the connection, the data from the mobile device will be piped into a file "android.dd".

````
nc 127.0.0.1 8888 > android.dd
````

Using the (Sleuthkit)[https://www.sleuthkit.org/] 'mmls' we can see the partition table of the disk image we collected:

````
mmls android.dd
````

The output should be something like the following:

````
GUID Partition Table (EFI)
Offset Sector: 0
Units are in 512-byte sectors

      Slot      Start        End          Length       Description
000:  Meta      0000000000   0000000000   0000000001   Safety Table
001:  -------   0000000000   0000008191   0000008192   Unallocated
002:  Meta      0000000001   0000000001   0000000001   GPT Header
003:  Meta      0000000002   0000000033   0000000032   Partition Table
004:  000       0000008192   0000016383   0000008192   BOTA0
005:  001       0000016384   0000024575   0000008192   BOTA1
006:  002       0000024576   0000065535   0000040960   EFS
007:  003       0000065536   0000073727   0000008192   m9kefs1
008:  004       0000073728   0000081919   0000008192   m9kefs2
009:  005       0000081920   0000090111   0000008192   m9kefs3
010:  006       0000090112   0000106495   0000016384   PARAM
011:  007       0000106496   0000122879   0000016384   BOOT
012:  008       0000122880   0000139263   0000016384   RECOVERY
013:  009       0000139264   0000319487   0000180224   RADIO
014:  010       0000319488   0000843775   0000524288   TOMBSTONES
015:  011       0000843776   0003465215   0002621440   CACHE
016:  012       0003465216   0008380415   0004915200   SYSTEM
017:  013       0008380416   0009527295   0001146880   HIDDEN
018:  014       0009527296   0009543679   0000016384   OTA
019:  015       0009543680   0061063167   0051519488   USERDATA

````

From this we can see that we have collected the physical disk.
