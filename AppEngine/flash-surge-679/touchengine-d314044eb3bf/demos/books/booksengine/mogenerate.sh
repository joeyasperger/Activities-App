#!/bin/bash

# TODO: check for mogenerator and warn we need to build mogenerator for release first.

mogenerator --template-path ../../../mogenerator/templates --model ../CoreDataBooks.xcdatamodel -M ./ -H ./ || exit 1

