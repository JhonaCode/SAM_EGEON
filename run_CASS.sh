#!/bin/bash
#help#

sam=`pwd`

case='CASS'

#####################
MICRO=SAM1MOM
#MICRO=M2005
#MICRO=THOM
#NC0=1200
#####################

#name="shsgp_${MICRO}_${NC0}"
name="shsgp_${MICRO}"
#5:30 da manha
#A radiozondagem foi feita para essa hora

day0=205.5
ntop=52200
#name_lsf='large'
name_lsf="${name}"
name_run="MONANR_${name}"


hours_run='12:00:00'

#config=1024x1024_100m_166_50m_1s_TKE15
#config="1024x1024_100m_166_50m_1s_${MICRO}_${NC0}"
config="1024x1024_100m_166_50m_1s_${MICRO}"

restar=0

#row='PESQ1'
row='PESQ2'
#row='BATCH'

#number of process
np=512
#np=1024

id=${name}_${config}

############################################
sed -e "s/########CASE/${case}/g" \
       ${sam}/CaseName_orig > ${sam}/CaseName

############################################

sed -e "s/!!!!!caseid/${id}/g" \
    -e "s/!!!!!day0/${day0}/g" \
    -e "s/!!!!!nstop/${ntop}/g" \
    -e "s;#####_NC0;${NC0};g"\
    -e "s/!!!!!restart/${restar}/g" \
       ${sam}/${case}/prm_orig > ${sam}/${case}/prm
#       ${sam}/${case}/prm_50 > ${sam}/${case}/prm
############################################

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
 
