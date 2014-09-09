#!/bin/bash

# TODO: check for mogenerator and warn we need to build mogenerator for release first.
# TODO: check for the output paths and, if they don't exist, make them.

../../mogenerator/build/Release/mogenerator --template-path ../../mogenerator/templates --model ./demoApp.xcdatamodel -M ./ -H ./ || exit 1

