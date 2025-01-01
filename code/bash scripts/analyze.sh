#!/bin/bash
#SBATCH --job-name=computeDescriptors
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=8:00:00
#SBATCH -p image2
/opt/MATLAB/R2018a/bin/matlab -nosplash -nodesktop -r "analyze(1)"
