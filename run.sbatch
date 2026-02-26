#!/bin/bash
#SBATCH --job-name=h24
#SBATCH --output=outputs/n2_%j.out
#SBATCH --error=outputs/n2_%j.err

#SBATCH --account=pi-ftchong
#SBATCH --partition=caslake
#SBATCH --constraint=gold-6248r

#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12

#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=zhassman@uchicago.edu

# Activate conda environment
source ~/.bashrc
conda activate match

# Force Python to flush output immediately
export PYTHONUNBUFFERED=1

# Set default parameters (can be overridden by setting environment variables)
export TRAJECTORY_COUNT=${TRAJECTORY_COUNT:-1000}
export SEED=${SEED:-1}
export SAMPLES_PER_BATCH=${SAMPLES_PER_BATCH:-2000}
export MAX_ITERATIONS=${MAX_ITERATIONS:-5}
export NUM_BATCHES=${NUM_BATCHES:-1}
export MATCH_IDX="${MATCH_IDX:-1}"
export CHOOSE_BEST=${CHOOSE_BEST:-1}
export MAX_DIM=${MAX_DIM:-2000}
export CARRYOVER_THRESHOLD=${CARRYOVER_THRESHOLD:-1e-4}
export NO_C_PHASE_GATES=${NO_C_PHASE_GATES:-0}
export SYMMETRIZE_SPIN=${SYMMETRIZE_SPIN:-1}
export PRINT_INFO=${PRINT_INFO:-1}

# Print job information
echo "Job ID: $SLURM_JOB_ID"
echo "Job name: $SLURM_JOB_NAME"
echo "Node: $SLURM_NODELIST"
echo "CPUs per task: $SLURM_CPUS_PER_TASK"
echo "Start time: $(date)"

# Print parameters being used
echo "Parameters:"
echo "  Trajectory count: $TRAJECTORY_COUNT"
echo "  Seed: $SEED"
echo "  Samples per batch: $SAMPLES_PER_BATCH"
echo "  Max iterations: $MAX_ITERATIONS"
echo "  Num batches: $NUM_BATCHES"
echo "  Match index: $MATCH_IDX"
echo "  Choose best: $CHOOSE_BEST"
echo "  Max dim: $MAX_DIM"
echo "  Carryover threshold: $CARRYOVER_THRESHOLD"
echo "  No C phase gates: $NO_C_PHASE_GATES"
echo "  Symmetrize spin: $SYMMETRIZE_SPIN"
echo "  Print info: $PRINT_INFO"

# Change to the directory where the script is located
cd $SLURM_SUBMIT_DIR

# Run your Python script with the parameters (unbuffered output)
python -u run.py \
    --trajectory_count $TRAJECTORY_COUNT \
    --seed $SEED \
    --samples_per_batch $SAMPLES_PER_BATCH \
    --max_iterations $MAX_ITERATIONS \
    --num_batches $NUM_BATCHES \
    --choose_best $CHOOSE_BEST \
    --max_dim $MAX_DIM \
    --carryover_threshold $CARRYOVER_THRESHOLD \
    --no_c_phase_gates $NO_C_PHASE_GATES \
    --symmetrize_spin $SYMMETRIZE_SPIN \
    --print_info $PRINT_INFO \
    ${MATCH_IDX:+--match_idx $MATCH_IDX}

# Print completion time
echo "End time: $(date)"
echo "Job completed successfully"
