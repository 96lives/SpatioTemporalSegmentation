#!/bin/bash

set -x
# Exit script when a command returns nonzero state
set -e

set -o pipefail

export PYTHONUNBUFFERED="True"

export BATCH_SIZE=${BATCH_SIZE:-9}

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")

export LOG_DIR=./outputs/ScanNet$2/$TIME

# Save the experiment detail and dir to the common log file
mkdir -p $LOG_DIR

LOG="$LOG_DIR/$TIME.txt"

python main.py \
    --log_dir $LOG_DIR \
    --dataset ScannetVoxelization2cmDataset \
    --model Res16UNet34C \
    --lr 0 \
    --batch_size 1 \
    --scheduler PolyLR \
    --max_iter 120000 \
    --train_limit_numpoints 1200000 \
    --train_phase trainval \
    --is_train True\
    --weights ./data/models/Mink16UNet34C_ScanNet.pth \
    --val_freq 1\
    --batch_size 1\
    $3 2>&1 | tee -a "$LOG"

