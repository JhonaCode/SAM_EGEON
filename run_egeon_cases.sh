#!/bin/bash
#help#

sam=`pwd`

sam_repo=/pesq/dados/bamc/jhonatan.aguirre/repositories/sam/SAM6.11.4/GOAMAZON_LES/python/forcing_fernao/scm_lsf_composites

case='GOAMAZON_LES'

#####################
#MICRO=SAM1MOM
#MICRO=M2005
MICRO=THOM
NC0=1200
#####################

#name='shca_tke15'
name="shca_${MICRO}_${NC0}"
#name="shca_TH_${NC0}"
#name='shca_TH_300'
#name='small'
#name='large'
#name='medium'
#4:30 da manha
day0=0.1875
#name_lsf='large'
name_lsf="${name}"
name_run="MONANR_${name}"



hours_run='12:00:00'

#config=1024x1024_100m_166_50m_1s_TKE15
config="1024x1024_100m_166_50m_1s_${MICRO}_${NC0}"

restar=1

#row='PESQ1'
row='PESQ2'
#row='BATCH'

#number of process
np=512
#np=1024

id=${name}_${config}

############################################

cp $sam_repo/lsf_${name_lsf}_p $sam/$case/lsf
cp $sam_repo/sfc_${name_lsf}   $sam/$case/sfc
cp $sam_repo/snd_${name_lsf}   $sam/$case/snd

echo $sam_repo/lsf_${name_lsf}_p   $sam/$case/lsf
echo $sam_repo/snd_${name_lsf}   $sam/$case/snd
echo $sam_repo/sfc_${name_lsf}   $sam/$case/sfc


sed -e "s/!!!!!caseid/${id}/g" \
    -e "s/!!!!!day0/${day0}/g" \
    -e "s;#####_NC0;${NC0};g"\
    -e "s/!!!!!restart/${restar}/g" \
       ${sam}/${case}/prm_orig > ${sam}/${case}/prm
#       ${sam}/${case}/prm_50 > ${sam}/${case}/prm

sed -e "s;#####_super;${row};g"\
    -e "s;#####_np;${np};g"\
    -e "s;#####_name;${name_run};g"\
    -e "s;#####_hours;${hours_run};g"\
    -e "s;#####_MICRO;${MICRO};g" \
    -e "s;#####_loc;${sam};g"\
       ${sam}/run_orig.slrm > ${sam}/run.slurm


cd $sam

sbatch run.slurm

squeue

#tail -f dados_${name}.dat
 
