#!/usr/bin/env bash

# Ensure PWD env is correct before launching
export PWD="/data/openpilot"
cd /data/openpilot
exec ./launch_openpilot.sh
