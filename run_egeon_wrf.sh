#!/bin/bash

module load anaconda3-2022.05-gcc-11.2.0-q74p53i


#####filex='20180704'
filex='20190707'

sam=`pwd`


dadosl=/pesq/dados/bamc/jhonatan.aguirre/DATA/LASSO

sam_repo=${dadosl}/lasso_sam_$filex/config

cp ${dadosl}/sam_input_generation.py  $sam_repo/


# go to the localization of the data and the program to gerenate the forcing 
cd $sam_repo

echo `pwd`

#to create the forcing from WRF.nc to SAM forcings.

python $sam_repo/sam_input_generation.py

module unload anaconda3-2022.05-gcc-11.2.0-q74p53i



while IFS= read -r line
    do
	if [[ "$i" == '2' ]]
	then
		line2=$line
        	echo "$line"
                echo "Number $i!"
                break
        fi
        #echo $i
        ((i++))
    done < sfc

echo ${line2:0:6}


#return to the running folder
cd $sam  


case=LASSO

#name_lsf='medium_tq_large_lsf'
#name_run='m_tq_l'
name_lsf=${filex}
name_run=${filex}

hours_run='4:00:00'

config=144x226_100_50m_0p5

restar=0

row='PESQ1'

#number of process
np=144


day0=${line2:0:6}

id=${name_lsf}_${config}

############################################

#cp $sam_repo/lsf_${name_lsf}   $sam/$case/lsf
#cp $sam_repo/sfc_${name_lsf}   $sam/$case/sfc
#cp $sam_repo/snd_${name_lsf}   $sam/$case/snd

cp $sam_repo/lsf   $sam/$case/lsf
cp $sam_repo/sfc   $sam/$case/sfc
cp $sam_repo/snd   $sam/$case/snd

echo $sam_repo/lsf  to  $sam/$case/lsf
echo $sam_repo/snd  to  $sam/$case/snd
echo $sam_repo/sfc  to  $sam/$case/sfc


sed -e "s/!!!!!caseid/${id}/g" \
    -e "s/!!!!!day0/${day0}/g" \
    -e "s/!!!!!restart/${restar}/g" \
       ${sam}/${case}/prm_orig_2 > ${sam}/${case}/prm

sed -e "s;#####_super;${row};g"\
    -e "s;#####_np;${np};g"\
    -e "s;#####_name;${name_run};g"\
    -e "s;#####_hours;${hours_run};g"\
    -e "s;#####_loc;${sam};g"\
       ${sam}/run_orig.slrm > ${sam}/run.slurm

cd $sam


sbatch run.slurm

squeue

tail -f dados_${name_run}.dat
 
