droiuby-doo
===========

Easy android development and prototyping using ruby. This GEM provides tools to allow easy development using the droiuby framework on Android (https://github.com/jedld/droiuby). The droiuby framework allows for rapid prototyping and development of mobile apps on Android using ruby. Droiuby is powered by JRuby and sits on top of the Android framework, this means your ruby apps are capable of accessing all of the features of your phone.

Pre installation requirements
=============================

* Ruby 1.9.3 (MRI will do but JRuby is recommended)

* Android SDK

  Grab the Android SDK (http://developer.android.com/sdk/index.html) and set it up.
  Make sure <sdk>/tools and <sdk>/platform-tools are in your path

  To make sure that android tools is properly installed make sure that the "adb" tool works in the commandline.

  The Android SDK is high recommended but optional, however you may need to perform extra steps in order to test your app.
  See section on "testing without the Android SDK".

* Phone with Android 4.0+ (Make sure you enable "developer mode", this can be different depending on your phone's vendor so just google it), Alternatively you may just use the Emulator if you already have the Android SDK downloaded.

Installation
============

Install gem

    gem install droiuby

Install the droiuby app on your android phone or tablet:

    https://play.google.com/store/apps/details?id=com.droiuby.application

Also if this is your first time developing for android make sure your phone is set up for development mode (This depends on your phone and android version). If you are unable to setup developer mode see "Testing without the android SDK".

Quick Start Tutorial
====================

This tutorial assumes you have installed the Android SDK and attached your android phone to the computer. This should also work on the android emulator but you must install the droiuby application on the emulator manually.

Create a new project

    ~ $ drby new hello_world
    ~ $ cd hello_world

Package and Execute the app. At this point make sure your phone is connected to your computer via the usb cable.

    ~ $ drby gopack

If successful, droiuby should boot and load your "hello world" app. If it does not, you may attempt to run droiuby manually from your phone and then repeat the previous step.

Testing without the Android SDK
===============================

You should be able to perform steps 1 & 2 of above without the android SDK, however drby will not be able to upload your app automatically. For this to work, drby will try to connect to your phone via your wifi network.

Things you need:

- Your computer's IP address
- Your phone's IP address

You should be able to retrieve your phone's IP address by running the droiuby app. It will display the detected IP address on the app (under the run button).
You can obtain your comptuer's IP address using ifconfig (if running on linux)

Create a new project (same as above)

Package and Execute the app. At this point make sure droiuby is running on your phone.

    drby gopack -d [Your phone's IP address]
    
Example

    cd my_awesome_app
    drby gopack -d 192.168.1.3

If all goes well you should see the "hello world" app on your phone.

Note:

You can also set the DROIUBY_HOST and DROIUBY_DEVICE environment variables.

Access to the console
=====================

Make sure your phone is connected (via usb) and the Droiuby App is running. Console access can be had by:

    ~ $ drby console

It should launch an irb like interface. ruby code here will run under the current app context inside the Droiuby application.

If you don't have the android sdk installed (thus no adb command) you may bring up the browser console:

    http://<your phone's IP address>:4000

Either that or you can specify your phones IP address (e.g. 192.168.1.2):

    ~ $ drby console -d 192.168.1.2

Make sure droiuby is running when you do this.


Testing on the Emulator
=======================

In order to test on the Android Emulator, you need to be able to install the droiuby app.

Get a hold of the droiuby APK. You may do this by getting the compiled binary from git@github.com:jedld/droiuby.git or building droiuby yourself (refer to the "customization" docs)

First, make sure the emulator is running and then do a "adb install"

    adb install droiuby.apk
    
The emulator should work as if it was a phone connected via usb and the drby commands should work fine.

Sample Applications
===================

Sample apps can be found here:

    git@github.com:jedld/droiuby_smples.git

Logs
====

Errors and such should show up inside logcat. Make sure you have the android sdk installed

    adb logcat | grep com.droiuby

Documentation on the Droiuby Framework
======================================

Details on the Droiuby Framework and how to create an app can be found here:

https://github.com/jedld/droiuby/wiki

Author
=======

Joseph Emmanuel Dayo (joseph.dayo@gmail.com)

License
=======

Copyright 2013 Joseph Emmanuel Dayo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.




