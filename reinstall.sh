#!/bin/sh

rm *.gem
gem uninstall droiuby -a -x
gem build droiuby.gemspec

FILENAME=$(ls -1 | grep *.gem | tail -1)
echo "installing $FILENAME"
gem install $FILENAME
