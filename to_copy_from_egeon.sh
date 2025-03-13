#!/bin/bash

out_loc=/pesq/dados/bamc/jhonatan.aguirre/git_repositories/PAPER2_SHCA


#Name of the the experiment 
#Exp=GOAMAZON_LES_small_1024x1024_100m_166_50m_1s
#exp_name='small'
#Exp=GOAMAZON_LES_shca_1024x1024_100m_166_50m_1s
#exp_name='shca'
#Exp=GOAMAZON_LES_large_1024x1024_100m_166_50m_1s
#exp_name='large'
#Exp=GOAMAZON_LES_medium_1024x1024_100m_166_50m_1s
#exp_name='medium'
#Exp=GOAMAZON_LES_medium_1024x1024_100m_166_50m_1s
#exp_name='medium'
#Exp=GOAMAZON_LES_shca_M5_300_1024x1024_100m_166_50m_1s_M2005_300
#exp_name='shcaM5300'
#Exp=GOAMAZON_LES_shca_THOM_1200_1024x1024_100m_166_50m_1s_THOM_1200
#exp_name='shcaTH1200'
Exp=GOAMAZON_LES_shca_M2005_1200_1024x1024_100m_166_50m_1s_M2005_1200
exp_name='shcaM51200'
#note="composto goamazon ${exp_name} 100m vertical 50m  1 seg micro TH"
#Exp=GOAMAZON_LES_shca_tke15_1024x1024_100m_166_50m_1s_TKE15
#exp_name='shcaTH'
note="composto goamazon ${exp_name} 100m vertical 50m  1 seg NC0=1200 micro M2005"

case="GOAMAZON_LES"

#Name to python program

#Parameters name
paraname="sam"

#year=${exp_name:1:4}
#month=${exp_name:5:2}
#day=${exp_name:7:2}

year='2025'
month='01'
day='01'

hi=7
hf=19

echo "${day}/${month}/${year}"

#Inicial day of the experiment
di=($year,$month,$day,$hi)
df=($year,$month,$day,$hf)

#Inicial day of the experiment to diurnal plots
did=($year,$month,$day,$hi)
dfd=($year,$month,$day,$hf)

#Program to read the variabls
program='sam'

calendar="['days  since ${year}-${month}-${day} 00:00:00 +00:00:00','gregorian']"

var1d="'MCUP','QC'"
var2d="'MCUP','QC'"
vars_diurnal="'MCUP','QC'"


#Number of processes used to run
np=144

####if stat files
d1='yes'

####if 2d files
d2='no'

####if 2d files
d3='no'

repo_loc=`pwd`

#OUT folder
#Where the repositorie of SAM will be located 
#out_loc="$dados/$case/SAM_OWN"
#out_loc=/pesq/dados/bamc/jhonatan.aguirre/SHALLOW/shca_mesh
#out_loc=/pesq/dados/bamc/jhonatan.aguirre/SHALLOW/shca_100_mdpi

python_loc="${out_loc}/python"



#IN folder
exp_loc="${repo_loc}/${case}"
repo_out="${repo_loc}/OUT_STAT"
repo_2d="${repo_loc}/OUT_2D"
repo_3d="${repo_loc}/OUT_3D"


################################################################
#To define the folder of the experiment. 
#and to copy the files necessary to run the first time
################################################################

#Define the folder of the experiments
#Where the data will be save within the repo_loc
#exp_folder='testes_xc50'
#exp_folder='shca_experiments'
#exp_folder='shca_teste'

echo "Files from $exp_loc"
echo "To $out_loc"

########################################
########################################
#module swap PrgEnv-cray/6.0.10  PrgEnv-intel/6.0.10
##module load cray-netcdf/4.7.4.4
#module load cray-hdf5/1.12.0.4

if  [ -d "${out_loc}" ]; then
        echo "The folder ${out_loc}files exits, nothing to do"
else
        echo "Folder ${out_loc} was created"
        mkdir ${out_loc}
fi



if  [ -d "${out_loc}/OUT_prm" ]; then
        echo "The folder OUT_pmr files exits, nothing to do"
else
        echo "Folder OUT_prm was created"
        mkdir ${out_loc}/OUT_prm
fi

if  [ -d "${out_loc}/OUT_STAT" ]; then
        echo "The folder OUT_STAT files exits, nothing to do"
else
        echo "Folder OUT_STAT was created"
        mkdir ${out_loc}/OUT_STAT
fi

if  [ -d "${out_loc}/OUT_2D" ]; then
        echo "The folder OUT_STAT files exits, nothing to do"
else
        echo "Folder OUT_2D was created"
        mkdir ${out_loc}/OUT_2D
fi

if  [ -d "${out_loc}/OUT_3D" ]; then
        echo "The folder OUT_STAT files exits, nothing to do"
else
        echo "Folder OUT_3D was created"
        mkdir ${out_loc}/OUT_3D
fi


out_2d="${out_loc}/OUT_2D"
out_3d="${out_loc}/OUT_3D"
out_stat="${out_loc}/OUT_STAT"
out_prm="${out_loc}/OUT_prm"

fernao_out=$(echo "$out_stat" | sed 's;pesq/;;g')

echo ${exp_loc}/prm


fileadd="yes"


if  [ -f "${out_stat}/${Exp}.nc" ]; then

        
        echo "The file exist and will be removed and update?"

	read -p "Are you sure? (y or n)" choice

	case "$choice" in 
  		y|Y ) echo "yes"; fileadd="yes"; echo "rm ${out_stat}/${Exp}.nc"; rm ${out_stat}/${Exp}.nc;;
  		n|N ) echo "no" ; fileadd="no" ; echo "Exit of the program";exit 7;;
 		* ) echo "invalid";;
	esac

else 
        echo "New file  will be added to  ${out_stat}"
fi



cp ${exp_loc}/prm $out_prm/prm_$Exp


#Transfor to nc
if [ ${d1} = 'yes' ];then

	$repo_loc/UTIL/stat2nc  ${repo_out}/${Exp}.stat

	cp ${repo_out}/$Exp.nc $out_stat
fi


if [ ${d2} = 'yes' ];then
	$repo_loc/UTIL/2Dcom2nc ${repo_2d}/${Exp}_${np}.2Dcom

	cp ${repo_2d}/${Exp}_${np}.2Dcom_1.nc $out_2d
fi


if [ ${d3} = 'yes' ];then

	for  file3d in ${repo_3d}/${Exp}_*.com3D
	do
		$repo_loc/UTIL/com3D2nc ${file3d}
	done

	cp ${repo_3d}/${Exp}_*.nc $out_3d

fi

################################################################
#Below it is no necesary to modify. 
################################################################

out_py="$python_loc"

# Parameters files, in this file will be save the 
# run location and adress. 
pyfile="${out_py}/Parameters_$paraname.py"

 
if  [ -d "${out_py}" ]; then
        echo "The folder ${out_py} files exits, nothing to do"
else
        echo "Folder ${out_py} was created"
        mkdir ${out_py}
fi

###############################################################
###############################################################
echo "${pyfile}" 

if  [ -f "${pyfile}" ]; then

        echo "The Parameters_$paraname exist, them it will be update"
else
	########echo -e '#######################################################' > "${pyfile}"
	########echo -e "#File to define the direction of the ${program} runs."   >> "${pyfile}"
	########echo -e '#######################################################' >> "${pyfile}"
	########echo -e '\n'>> "${pyfile}"
	########echo -e '### My own files'>> "${pyfile}"
	########echo -e '\n'>> "${pyfile}"
	########echo -e '##Adress of the computer'>> "${pyfile}"
	########echo -e 'from     files_direction  import *'>> "${pyfile}"
	########echo -e '\n'>> "${pyfile}"
	########echo -e "import   sam_python.var_files.var_to_load_${program} as ${program}" >> "${pyfile}" 
	########echo -e '\n'>> "${pyfile}"
	########echo -e '#######################################################' >> "${pyfile}"
	########echo -e '#Files of SAM to load.' >> "${pyfile}"
	########echo -e '#######################################################' >> "${pyfile}"

	echo -e '# -*- coding: UTF-8 -*-'>> "${pyfile}"
	echo -e '###################################################' >> "${pyfile}"
	echo -e '#PYTHON CODE TO PLOT DIFFERENS' >> "${pyfile}" 
	echo -e '#MPAS DATA USING CARTOPY AND XARRAY.' >> "${pyfile}" 
	echo -e '###################################################' >> "${pyfile}"
	echo -e '#PYTHON CODE TO PLOT DIFFERENS' >> "${pyfile}" 
	echo -e '#End=`date +%s.%N`' >> "${pyfile}"
	echo -e '###################################################' >> "${pyfile}"
	echo -e '# By: Jhonatan A. A Manco'>> "${pyfile}"
	echo -e '###################################################' >> "${pyfile}"
	echo -e '# Function to load the complete ncfiles  of regional MONAN run' >> "${pyfile}"
	echo -e 'from   sam_python  import data_own as down' >> "${pyfile}"
	echo -e '' >> "${pyfile}"
	echo -e '#######################################################' >> "${pyfile}"
	echo -e '#Files of SAM to load.' >> "${pyfile}"
	echo -e '#######################################################' >> "${pyfile}"
	echo -e '#Path to the files' >> "${pyfile}" 
	echo -e '###################################################' >> "${pyfile}"
	echo -e "computer        ='/pesq'"                                 >> "$pyfile"


fi



if [ ${fileadd} = "yes" ];then


        if grep -q file_${exp_name} "$pyfile"; then
	
                echo "File found in Parameters_$paraname "
	
	else 
		file_n="file_${exp_name}"


		#echo "New file  added to python scrip: $file_n"
		#echo $out_stat/$Exp.nc
		#echo -e "\n" >> "$pyfile"
		#echo -e "name        	= '${exp_name}'">> "$pyfile"  
		#echo -e "#note       	= $note" >> "$pyfile"
		#echo -e "$file_n	= '$fernao_out/$Exp.nc'" >> "$pyfile"
		#echo -e "var1d       	= [${var1d}] "   >> "$pyfile" 
		#echo -e "var2d       	= [${var2d}] "   >> "$pyfile"
		#echo -e "vars_diurnal	= [${vars_diurnal}]">> "$pyfile"
		#echo -e "date        	= [(${di}),(${df})] " >> "$pyfile"
		#echo -e "date_diurnal	= [(${did}),(${dfd})] " >> "$pyfile"
		#echo -e "cal         	= ${calendar}" >> "$pyfile"
		#echo -e "${exp_name} 	= ${program}.ncload(name,date,$file_n,cal,var1d,var2d,vars_diurnal,date_diurnal)" >> "$pyfile"

		echo -e "\n" >> "$pyfile"
		echo -e "#-----------------------------------------------------"    >> "$pyfile"
		echo -e "#note\t= ${note}"                                >> "$pyfile"
		echo -e "tu\t= ${calendar}"                            >> "$pyfile"
		echo -e "exp_name\t= '${exp_name}'"                          >> "$pyfile"                       
		#echo -e "path_${exp_name}\t= '%s${out_stat}/${Exp}.nc'%(computer)"  >> "$pyfile"
		echo -e "path_${exp_name}\t= '${out_stat}/${Exp}.nc'"  >> "$pyfile"
		echo -e "${exp_name}\t= down.data_load_xr(path_${exp_name}, exp_name, tu)" >> "$pyfile"
	fi

else 

echo "Nothing to do"

fi


