droiuby-doo
===========

Easy android development and prototyping using ruby. This GEM provides tools to allow easy development using the droiuby framework on Android (https://github.com/jedld/droiuby). The droiuby framework allows for rapid prototyping and development of mobile apps on Android using ruby. Droiuby is powered by JRuby and sits on top of the Android framework, this means your ruby apps are capable of accessing all of the features of your phone.

Pre installation requirements
=============================

* Ruby 1.9.3 (MRI will do but JRuby is recommended)

* Android SDK (Recommended but optional as long as your Android Phone is on wifi)

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

Also if this is your first time developing for android make sure your phone is
set up for development mode (This depends on your phone and android version).
If you are unable to setup developer mode see "Testing without the android SDK".

Quick Start Tutorial
====================

This tutorial assumes you have installed the Android SDK and attached your android phone to the computer. This should also work on the android emulator but you must install the droiuby application on the emulator manually.

Create a new project

    ~ $ drby new hello_world
    ~ $ cd hello_world

Package and Execute the app. At this point make sure your phone is connected to your computer via the usb cable.

    ~ $ drby go

If successful, droiuby should boot and load your "hello world" app. If it does not, you may attempt to run droiuby manually from your phone and then repeat the previous step.

It is also possible to generate a standalone android project.

chdir to your target project and

    ~ $ drby standalone --package com.sample.helloworld

This will create an android project at hello_world/project. `drby go` will detect if
you have a project and automatically invoke ant to build and install it. Alternatively,
you can then open this using Android Developer Tools and build it normally using eclipse.

If you use Android Studio, you can generate a gradle project instead

    ~ $ drby standalone --package com.sample.helloworld --gradle

Diving in
---------

A simple "Hello World" is not enough? Let's try to add a button and an action
that changes the "Hello World" text from a text field when that happens.

But ... before we try to modify our "Hello World" project, let's look at what we have...

The "drby new" command should generate the project structure below:

    hello_world
    ├── Gemfile
    ├── Gemfile.lock
    ├── app
    │   ├── activities
    │   │   └── index.rb
    │   └── views
    │       ├── index.xml
    │       └── styles
    │           └── application.css
    ├── build
    │   └── hello_world.zip
    ├── config.droiuby
    ├── lib
    ├── project
    └── vendor

Here is a brief overview of what those folders and files are about:

Gemfile - The standard Gemfile that contains the list of gems that the app is
dependent upon. It is used by bundler to download the necessary gem dependencies.
Right now only the 'droiuby' gem is listed. Droiuby supports most gems that work on JRuby.

app/ The app folder contains the actual application code. We will get to this later.

build/ - The build folder will contain the build artifacts.

config.droiuby - is an xml file that contains metadata about the project and is used
when booting the app inside android.

lib/ - The lib folder is where you can place your .rb files that don't belong in app/

project/ - The project folder is where the standalone Android project files are
located if you invoked the "drby standalone" command.

vendor/ - The vendor folder is where the project gem dependencies are stored.

Now Let's look at the app folder

    app
    ├── activities
    │   └── index.rb
    └── views
        ├── index.xml
        └── styles
            └── application.css

The activities folder contain code related to handling "Activities" on Android. If
you are using rails you can think of them as controllers.

The views folder contain templates and styles for rendering UI, such as forms, fields, lists etc.

So let's first add a button. Open up index.xml

    <activity controller="app/activities/index.rb#index">
        <preload id="application_css" src="app/views/styles/application.css" type="css"/>
        <layout type="linear" width="match" height="match" orientation="vertical">
        	<t>Hello World!</t>
        </layout>
    </activity>

Let's add the button tag after hello world so it looks like this

    ...
    <layout type="linear" width="match" height="match" orientation="vertical">
      <t>Hello World!</t>
      <button id="click">Click Me!</button>
    </layout>
    ...

Notice we also set an id "click" for the button tag, we will need that later. While
we are at it let's make sure the "Hello World" text also has an id.

    <t id="target">Hello World!</t>

And then the text field and set an id

    ...
    <layout type="linear" width="match" height="match" orientation="vertical">
      <t>Hello World!</t>
      <input id="hello_field" type="text" width="match" height="wrap" hint="Enter Values" />
      <button id="click">Click Me!</button>
    </layout>
    ...

Ok, so let's modify the activity script. We now open up index.rb

    #droiuby ruby script
    class Index < Activity
    	def on_create
    	  #called when activity is first created
    	end

    	def on_activity_result(request_code, result_code, intent)
    	  #callback from starting an activity with result
    	end
    end

Let's attach an on click event to the button we created earlier

    ...
    def on_create
      V('#click').on(:click) { |view|
      }
    end
    ...

Noticed that we used V('#click') to select the button. Now let's add some action.

First we also select the text field and the "Hello World" text

    ...
    def on_create

      @hello_text_field = V('#hello_field')
      @hello = V('#target')

      V('#click').on(:click) { |view|
      }
    end
    ...

Then add code to change the text when "Click Me!" is pressed.

    ...
    def on_create

      @hello_text_field = V('#hello_field')
      @hello = V('#target')

      V('#click').on(:click) { |view|
        @hello.text = @hello_text_field.text
      }
    end
    ...

And we're done. Let's run the app to make sure it works

    drby go

To Learn more on how to develop apps using droiuby please proceed to the Droiuby Wiki

[Droiuby Wiki](https://github.com/jedld/droiuby/wiki)

Testing without the Android SDK
===============================

You should be able to perform steps 1 & 2 of above without the android SDK, however drby will not be able to upload your app automatically. For this to work, drby will try to connect to your phone via your wifi network.

There are two ways to upload your app to your phone, via the Droiuby Web Console or still, via the commandline.

Using the Droiuby Web Console
-----------------------------

Create a new project (same as above) and cd into it.

Package the app

    drby pack

This will create a zip file under the build directory, we will upload this zip file later.

On your phone, make sure you have downloaded the droiuby app:

    https://play.google.com/store/apps/details?id=com.droiuby.application&hl=en

Run it, and once Droiuby has finished loading, your phone's IP address and the WebConsole port will be displayed on-screen.

Open the web browser on your PC and enter the following URL:

    http://<Your Phone's IP>:4000

You should see the IRB like interface of the Droiuby Console, there wil be a link to upload your file, click on the link.

Browse and select the zip file that was created by the pack command. This will upload the app to your phone and run it.

Via the commandline
-------------------

Things you need:

- Your computer's IP address
- Your phone's IP address

You should be able to retrieve your phone's IP address by running the droiuby app. It will display the detected IP address on the app (under the run button).
You can obtain your comptuer's IP address using ifconfig (if running on linux)

Create a new project (same as above)

Package and Execute the app. At this point make sure droiuby is running on your phone.

    drby go -d [Your phone's IP address]

Example

    cd my_awesome_app
    drby go -d 192.168.1.3

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

    https://github.com/jedld/droiuby_samples

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
