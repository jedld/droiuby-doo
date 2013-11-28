droiuby-doo
===========

Easy android development and prototyping using ruby

Pre installation requirements
=============================

* Ruby

* Android SDK

  Grab the Android SDK (http://developer.android.com/sdk/index.html) and set it up.
  Make sure <sdk>/tools and <sdk>/platform-tools are in your path

  To make sure that the android tools is properly installed make sure that the "adb" works in the commandline.
  
  The Android SDK is optional but you may need to perform extra steps in order to test your app.
  See section on "testing without the Android SDK".

Installation
============

Install gem

    gem install droiuby

Install the droiuby app on your android phone or tablet:

    https://play.google.com/store/apps/details?id=com.droiuby.application

Also if this is your first time developing for android make sure your phone is set up for development mode.

Quick Start Tutorial
====================

This tutorial assumes you have installed the Android SDK and attached your android phone to the computer. This should also work on the android emulator but you must install the droiuby application on the emulator manually.

1.  Create a new project

    drby new hello_world
    cd hello_world

2.  Package and Execute the app. At this point make sure your phone is connected to your computer via the usb cable.

    drby gopack

3. If successful, droiuby should boot and load your "hello world" app. If it does not you may attempt to run droiuby manually from your phone and then repeat step 2.

Testing without the Android SDK
===============================

You should be able to perform steps 1 & 2 of above without the android SDK, however drby will not be able to upload your app automatically. For this to work, drby will try to connect to your phone via your wifi network.

Things you need:

- Your computer's IP address
- Your phone's IP address

You should be able to retrieve your phone's IP address by running the droiuby app. It will display the detected IP address on the app.
You can obtain your comptuer's IP address using ifconfig (if running on linux)

1. Create a new project (same as above)

2. Package and Execute the app. At this point make sure droiuby is running on your phone.

    DROIUBY_HOST=[your computer's IP address] drby gopack [Your phone's IP address]

3. If all goes well you should see the "hello world" app on your phone.

Documentation on the Droiuby Framework
======================================

Details on the Droiuby Framework and how to create an app can be found here:

https://github.com/jedld/droiuby/wiki





