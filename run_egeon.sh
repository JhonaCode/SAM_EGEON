#!/bin/bash
#help#

sam=`pwd`

#sam_repo=/pesq/dados/bamc/jhonatan.aguirre/git_repositories/LASSO/python/lsf_cases/

#sam_repo=/pesq/dados/bamc/jhonatan.aguirre/git_repositories/LASSO/python/lsf_cases_mixing/
sam_repo=/pesq/dados/bamc/jhonatan.aguirre/git_repositories/sam/SAM6.11.4/GOAMAZON_LES/python/forcing_fernao/iop2_scm
#sam_repo=/pesq/dados/bamc/jhonatan.aguirre/git_repositories/sam/SAM6.11.4/GOAMAZON_LES/python/forcing_fernao/iop1_scm


case='GOAMAZON_LES'

name='composto_100xvar'
day0=0.375
name_lsf='iop2_scm'
#name_lsf='iop1_scm'
#name='mar_10'
#day0=69.375
#name='oct01'
#day0=274.375
#name='oct05'
#day0=278.375
#name='oct08'
#day0=281.375
name_run="MONANR_${name}"

#######################

#fazer
###!!!
##

hours_run='24:00:00'

config=1024x1024_100m_166_50m_1s
#config=2048x2048_50m_166_50m_1s

restar=0

row='PESQ2'

#number of process
np=512
#np=1024

id=${name}_${config}

############################################

#cp $sam_repo/lsf_${name_lsf}_p $sam/$case/lsf
#cp $sam_repo/sfc_${name_lsf}   $sam/$case/sfc
#cp $sam_repo/snd_${name_lsf}   $sam/$case/snd

#
#
#echo $sam_repo/lsf_${name_lsf}_p   $sam/$case/lsf
#echo $sam_repo/snd_${name_lsf}   $sam/$case/snd
#echo $sam_repo/sfc_${name_lsf}   $sam/$case/sfc


sed -e "s/!!!!!caseid/${id}/g" \
    -e "s/!!!!!day0/${day0}/g" \
    -e "s/!!!!!restart/${restar}/g" \
       ${sam}/${case}/prm_orig > ${sam}/${case}/prm
#       ${sam}/${case}/prm_50 > ${sam}/${case}/prm

sed -e "s;#####_super;${row};g"\
    -e "s;#####_np;${np};g"\
    -e "s;#####_name;${name_run};g"\
    -e "s;#####_hours;${hours_run};g"\
    -e "s;#####_loc;${sam};g"\
       ${sam}/run_orig.slrm > ${sam}/run.slurm

cd $sam

sbatch run.slurm

squeue

#tail -f dados_${name}.dat
 
