---
layout: single
title: "Oculus Quest 2 First Impressions and Research Notes"
permalink: /:year/:month/:title
date: "2022-04-08T15:17:34-05:00"
tags:
  - infosec
  - dfir
  - oculus
  - vr
header:
  og_image: "/assets/images/posts/cards/oculus_card.png"
  image: "/assets/images/posts/headers/oculuscover.png"
  caption:
modified_time:
---
 
Recently the [DFIR Community Hardware Fund](https://github.com/DFIRScience/DFIRCommunityHardwareFund) purchased a Meta Oculus Quest 2 VR headset. Unboxing and device images can be found [here](https://github.com/DFIRScience/DFIRCommunityHardwareFund/tree/main/MetaQuest2/images/unboxing). I finally had time to set the device up and play with it a bit to see what it's all about and possible forensic implications. All data, updates and documents for Oculus Quest 2 Forensics can be found [here](https://github.com/dfirscience/DFIRCommunityHardwareFund/tree/main/MetaQuest2).

# First impressions

When first connecting the headset downloads an OS update. After, you are forced to sync the headset with the [Oculus app](https://play.google.com/store/apps/details?id=com.oculus.twilight). The app requires either an Oculus login (which you cannot create) or a Facebook login. Logging in with Facebook seems to create an Oculus account. The process looks like SSO after that.

You must enable detailed location in Android for the Oculus app to find the headset. Once found, the app lets you manage media, buy apps, stream "casting", social connect and configure headset settings. It looks like everything in the app can be done in the headset. The phone/app does not need to be connected to run the headset. A single sync seems to be enough to register the headset.

Once the headset is registered you go into your home room and run through a series of tutorials. Your Facebook-connected Oculus account icon shows in the dashboard. Facebook Messenger is automatically logged in.

## Interface

After using the headset for about 20 minutes my neck and face began hurting. The headset is quite heavy. After about an hour of usage, and about 10 minutes in RecRoom I felt motion sickness. The interface is always a bit blurry. Whatever you are focusing on becomes clearer, but there is so much blur and lense flair. You can ignore it, but it causes headaches over time. This seems to be similar to the [WSJ *Trapped in the Metaverse*](https://www.wsj.com/video/series/joanna-stern-personal-technology/trapped-in-the-metaverse-heres-what-24-hours-feels-like/820EA261-05CD-44E9-871C-8CFB8E65DBBF) experience.

The hand controllers are intuitive, but clunky. Almost everything is a trigger action. Grabbing things feels more natural than typing on the pop-up keyboard. You can enable hand tracking, but I'm not sure I'm ready for that.

# Technical Notes

* The system has it's own internal HD - syncing with cloud - some data synced with phone/app
The system is definitely built on Android.

![Oculus Quest 2 Operating System Information](/assets/images/posts/20220408-oculus-system.jpg)

* Cloud backup is also enabled by default. Unclear where the backup is stored.
* The user can enable a lock pattern for the headset.
* Built-in web browser - "Oculus Browser" based on Chromium
  * Browser has a 'private mode' setting

![Oculus Browser Based on Chromium](/assets/images/posts/20220408-oculus-browser.jpg)

* Up to 4 accounts can be connected to a single headset.
* App sharing is possible between accounts, but must be enabled.
* Connecting a headset to a computer shows Android "Internal Shared Storage" device *after allowing connection on the headset*.
* Each headset has a paring code - it looks like the headset can be paired with multiple apps at the same time? (verify)
  * Paring code found in Settings -> System -> About -> Paring Code
* Developer mode can only be enabled by a logged-in user account via the mobile app.
* Unlock pattern can be removed with app, but you need the Oculus pin
* The headset functions without an internet connection (though most apps don't work) - local media and apps work fine

## Enabling Developer Mode

I've not yet found a way to enable developer mode from within the headset. Instead you must register your Oculus/Facebook account as an [Oculus developer](https://developer.oculus.com/manage/verify/). Once registered, you need to create an 'Organization'. Once your account has been created, refresh the mobile app. Select Menu -> Devices, find your headset, and there should be a "Developer Mode" option. Select that and toggle the "Developer Mode" switch. Reset the headset.

# Oculus Quest 2 Forensics

An unlock pattern is not set by default. In that case it may be possible to access the user's account directly. Connecting the headset directly to a workstation (and enabling file-sharing permissions in the headset) gives access to non-protected storage. This storage includes some log info, media files, some app data. The storage device does not contain system settings, browser info, etc. Settings and media on the mobile app appear to sync to the headset via the cloud. The headset can function without an internet connection.

There does not appear to be any way to enable developer mode in the headset. Instead, a registered user's account must be set to developer, then developer mode should be enabled in the synced oculus mobile app. It appears that a single headset can be paired with multiple mobile apps/accounts if you have the headset paring code. An investigator may be able to add their (sock) developer account to get an acquisition. **This would likely require an internet connection to set up.**

## Minimal Acquisition

1. Ensure no possible known WIFI is in the area
2. Turn on the Quest 2 by pressing and holding the button on the right-hand side
3. Check for unlock pattern -> if yes, crack it.
4. Plug the headset USB C port into a forensic workstation
   * Select 'Allow File Access' in the headset when then connection is detected
5. The device will show as "Quest 2" in the forensic workstation. Image "Internal Shared Storage"

Here is an example of some of the files that may be available:

```bash
$ find .
.
./Pictures
./Pictures/.thumbnails
./Pictures/.thumbnails/31.jpg
./Pictures/.thumbnails/30.jpg
./Pictures/.thumbnails/32.jpg
./Oculus
./Oculus/Screenshots
./Oculus/Screenshots/com.oculus.shellenv-20220408-160913.jpg
./Oculus/Screenshots/com.oculus.shellenv-20220408-155449.jpg
./Oculus/Screenshots/com.AgainstGravity.RecRoom-20220408-145501.jpg
./Oculus/Avatars
./Music
./Podcasts
./Alarms
./Movies
./DCIM
./Notifications
./Download
./Android
./Android/data
./Android/data/com.AgainstGravity.RecRoom
./Android/data/com.AgainstGravity.RecRoom/cache
./Android/data/com.AgainstGravity.RecRoom/cache/UnityShaderCache
./Android/data/com.AgainstGravity.RecRoom/cache/UnityShaderCache/997dcf3d5d38aa491d0065c37daab1d6
./Android/data/com.AgainstGravity.RecRoom/cache/UnityShaderCache/43a05ff834d9153fed8ca10759074702
[SNIP]
./Android/data/com.AgainstGravity.RecRoom/files/backtrace
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database/crashpad
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database/crashpad/new
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database/crashpad/attachments
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database/crashpad/settings.dat
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database/crashpad/pending
./Android/data/com.AgainstGravity.RecRoom/files/backtrace/database/crashpad/completed
./Android/data/com.AgainstGravity.RecRoom/files/Cookies
./Android/data/com.AgainstGravity.RecRoom/files/Cookies/Library
./Android/data/com.AgainstGravity.RecRoom/files/Library
./Android/data/com.AgainstGravity.RecRoom/files/AnalyticsCache
./Android/data/com.AgainstGravity.RecRoom/files/AnalyticsCache/queued_events_
./Android/data/com.AgainstGravity.RecRoom/files/AnalyticsCache/queued_identify_
./Android/data/com.AgainstGravity.RecRoom/files/AnalyticsCache/prev_user_props_
./Android/data/com.oculus.shellenv
./Android/data/com.oculus.shellenv/files
./Android/data/com.oculus.shellenv/files/log
./Android/data/com.oculus.shellenv/files/log/shellenv.log.3
./Android/data/com.oculus.shellenv/files/log/shellenv.log.1
./Android/data/com.oculus.shellenv/files/log/shellenv.log.2
./Android/data/com.oculus.shellenv/files/log/shellenv.log
./Android/data/com.oculus.shellenv/files/misc
./Android/data/com.oculus.shellenv/files/misc/sessions
./Android/data/com.oculus.MiramarSetupRetail
./Android/data/com.oculus.MiramarSetupRetail/files
./Android/data/com.oculus.MiramarSetupRetail/files/login-identifier.txt
./Android/data/com.oculus.MiramarSetupRetail/files/ca-bundle.pem
./Android/data/com.facebook.arvr.quillplayer
./Android/data/com.facebook.arvr.quillplayer/files
./Android/data/com.oculus.avatar2
./Android/data/com.oculus.avatar2/cache
./Android/data/com.oculus.avatar2/cache/Oculus
./Android/data/com.oculus.avatar2/cache/Oculus/Avatars2
./Android/data/.nomedia
./Android/data/com.oculus.mrservice
./Android/data/com.oculus.mrservice/files
./Android/obb
./Android/obb/com.AgainstGravity.RecRoom
./Android/obb/com.AgainstGravity.RecRoom/main.1630155.com.AgainstGravity.RecRoom.obb
./Android/obb/com.oculus.shellenv
./Android/obb/com.oculus.MiramarSetupRetail
./Android/obb/com.facebook.arvr.quillplayer
./Android/obb/.nomedia
./Ringtones
```

Note that the thumbnails in ``Pictures`` were automatically created from the files under ``Screenshots``. RecRoom is a third-party app.

## Next Steps

The biggest gotcha so far seems to be the unlock pattern. If you pick up an unlocked Quest you can do everything as the logged-in user. This document is just first impressions. Here are some things we will do in the future.

* Enable debug mode and attempt ADB extraction
  * Android_triage script?
* Check [Magisk Canary](https://github.com/topjohnwu/Magisk) rooting Quest 2
* Specific case study of user activity
* Dismantle case and take pictures of electronics
  * look for JTAG?
* Create acquisition workflow document