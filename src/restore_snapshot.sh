#!/usr/bin/env bash

set -e 

# Quit script if snapshot file doesn't exist

if [ ! -f /snapshot.json ]; then
    echo "runpod-worker-comfy: No snapshot file found. Exiting..."
    exit 0
fi

cd /comfyui/

# Install ComfyUI-Manager
git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager
cd custom_nodes/ComfyUI-Manager
git checkout d30459cc34deef57aec3229a6b8185e488af4005
pip install -r requirements.txt

# Install ComfyUI_InstantID
cd ../..
git clone https://github.com/cubiq/ComfyUI_InstantID.git custom_nodes/ComfyUI_InstantID
cd custom_nodes/ComfyUI_InstantID
git checkout 72495e806bc2ab9c41581e15ccaa1bcf83c477e8
pip install -r requirements.txt

# Move snapshot file to startup-scripts
#mv /snapshot.json snapshots/restore-snapshot.json

cd ../..

# Trigger restoring of the snapshot by performing a quick test run
# Note: We need to use `yes` as some custom nodes may try to install dependencies with pip
/usr/bin/yes | python3 main.py --cpu --quick-test-for-ci