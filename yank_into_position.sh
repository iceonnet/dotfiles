#!/bin/bash

cp -r .i3/ ~/.i3/
cp .Xresources ~/.Xresources

i3-msg restart
echo Done