#!/bin/bash
#SBATCH --job-name=register
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=08:00:00
#SBATCH -p image2
/opt/MATLAB/R2018a/bin/matlab -nosplash -nodesktop -r "computeRegistrations(true, true); performRegistrations();"
