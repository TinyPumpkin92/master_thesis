#!/bin/bash
#SBATCH --job-name=segment
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH -p image2
/opt/MATLAB/R2018a/bin/matlab -nosplash -nodesktop -r "extractSubblocks"
