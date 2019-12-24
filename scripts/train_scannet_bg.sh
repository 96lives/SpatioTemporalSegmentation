export CUDA_VISIBLE_DEVICES=7

export BATCH_SIZE=2

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")

export LOG_DIR=./outputs/ScanNet$2/$TIME

# Save the experiment detail and dir to the common log file
mkdir -p $LOG_DIR

LOG="$LOG_DIR/$TIME.txt"

python main.py \
    --log_dir $LOG_DIR \
    --dataset ScannetVoxelizationBgDataset \
    --model Res16UNet34C \
    --lr 1e-2 \
    --batch_size $BATCH_SIZE \
    --scheduler PolyLR \
    --max_iter 60000 \
    --train_limit_numpoints 1200000 \
    --train_phase train \
    --weights ./data/models/Mink16UNet34C_ScanNet.pth \
    --lenient_weight_loading True \
    $3 2>&1 | tee -a "$LOG"

export TIME=$(date +"%Y-%m-%d_%H-%M-%S")
LOG="$LOG_DIR/$TIME.txt"

python main.py \
    --log_dir $LOG_DIR \
    --dataset ScannetVoxelizationBgDataset \
    --model Res16UNet34C \
    --lr 1e-3 \
    --batch_size $BATCH_SIZE \
    --scheduler PolyLR \
    --max_iter 60000 \
    --train_limit_numpoints 1200000 \
    --train_phase trainval \
    --weights ./data/models/Mink16UNet34C_ScanNet.pth \
    $3 2>&1 | tee -a "$LOG"
