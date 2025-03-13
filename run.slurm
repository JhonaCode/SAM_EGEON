#!/bin/bash
#SBATCH --job-name=MONANR_shca_THOM_1200
#SBATCH --ntasks=512
#SBATCH --partition=PESQ2
#SBATCH --time=12:00:00
cd $SLURM_SUBMIT_DIR
#time mpirun -np $SLURM_NTASKS /home/jhonatan.aguirre/SAM6.11.7/SAM_ADV_MPDATA_SGS_TKE_RAD_CAM_MICRO_SAM1MOM >> /home/jhonatan.aguirre/SAM6.11.7/dados_TESTE.out 
#mpirun -np $SLURM_NTASKS /home/jhonatan.aguirre/SHALLOW/SAM_ADV_MPDATA_SGS_TKE_RAD_CAM_MICRO_M2005 >> /home/jhonatan.aguirre/SHALLOW/dados_MONANR_shca_THOM_1200.out 
mpirun -np $SLURM_NTASKS /home/jhonatan.aguirre/SHALLOW/SAM_ADV_MPDATA_SGS_TKE_RAD_CAM_MICRO_THOM >> /home/jhonatan.aguirre/SHALLOW/dados_MONANR_shca_THOM_1200.out 
