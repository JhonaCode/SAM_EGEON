#!/bin/bash

#Name of the the experiment to download without extension  
Exp=GOAMAZON_LES_small_t_medium_wshf_lar_1024x150_100_50m_1s

#note to put 
#note='medium with w shf and t of large,  100 m resolution ' 
#note='small with q and shf of large,  100 m resolution ' 
note='small  with  t of  medium, and  w and shf of large  100 m resolution ' 
#note='medium , 100 m resolution ' 

#exp_name='s_qt_m_w_l'
exp_name='s_t_m_wshf_l'

#Inicial day of the experiment
di=(2014,1,1,9)
df=(2014,1,1,19)

#Inicial day of the experiment
did=(2014,1,1,9)
dfd=(2014,1,1,19)

#Program
program='sam'

calendar="['days  since 2014-01-01 00:00:00 +04:00:00','gregorian']"

var1d="'MCUP','QC'"
var2d="'MCUP','QC'"
vars_diurnal="'MCUP','QC'"

################################################################
#To define the folder of the experiment. 
#and to copy the files necessary to run the first time
################################################################


#Where the repositorie of SAM will be located 
#repo_loc='/home/jhona/repositories/sam/SAM6.11.4/GOAMAZON_LES/python/stat'
#repo_loc='/home/jhonatan.aguirre/'
repo_loc='/dados/bamc/jhonatan.aguirre/SHALLOW'

#Define the folder of the experiments
#Where the data will be save within the repo_loc
#exp_folder='testes_xc50'
#exp_folder='shca_experiments'
exp_folder='shca_teste'


#Paste where the remotes files are saved
HOME2=/lustre_xc50/nilo_figueroa/SAM/OUT_STAT
#to untar only the name without direction
numberoffolder=4
#Name of  machine where the files are located, to copy 
machine1=nilo_figueroa@login-Xc50.cptec.inpe.br

################################################################
#Below it is no necesary to modify. 
################################################################

out_py=`pwd`
out_loc="$repo_loc/$exp_folder"


if  [ -d "$out_loc/" ]; then

        echo "The folder exists, nothing to do"
        cd $repo_loc/$exp_folder  
else 
        echo "Making the experiment folder"

        cd $repo_loc/ 
        mkdir $exp_folder 

fi
            

# Parameters files, in this file will be save the 
# run location and adress. 
pyfile="${out_py}/Parameters.py"

#Make the folder to save the results from SAM run 
#if the folde does no exit it wiil created. 
if  [ -d "$out_loc/OUT_STAT" ]; then
        echo "The folder OUT_STAT files exits, nothing to do"
else 
        echo "Folder OUT_STAT was created"
        mkdir OUT_STAT
fi

if  [ -d "$out_loc/OUT_2D" ]; then
        echo "The folder OUT_2D files exits, nothing to do"
else 
        echo "Folder OUT_2D was created"
        mkdir OUT_2D
fi

if  [ -d "$out_loc/OUT_3D" ]; then
        echo "The folder OUT_3D files exits, nothing to do"
else 
        echo "Folder OUT_3D was created"
        mkdir OUT_3D
fi

if  [ -d "$out_loc/prm_files" ]; then
        echo "The folder prm_filesk files exits, nothing to do"
else 
        echo "Folder prm_files was created"
        mkdir prm_files
fi

out_stat=$out_loc/OUT_STAT
out_2D=$out_loc/OUT_2D
out_3D=$out_loc/OUT_3D

#Folde to save the prm of the SAM run. 
prmfolder=$out_loc/prm_files


echo files_${Exp}.tar.gz

fileadd="yes"

if  [ -f "${out_stat}/files_${Exp}.tar.gz" ]; then

        
        echo "The file exist and will be removed and update?"

	read -p "Are you sure? (y or n)" choice

	case "$choice" in 
  		y|Y ) echo "yes"; fileadd="yes"; echo "rm  ${out_stat}"; rm ${out_stat}/files_${Exp}.tar.gz;;
  		n|N ) echo "no" ; fileadd="no" ;;
 		* ) echo "invalid";;
	esac

	#read -p "Are you sure? (Y or N) " -n 1 -r
	#echo    # (optional) move to a new line
	#if [[ $REPLY =~ ^[Yy]$ ]]
	#then
    	#	do dangerous stuff
	#fi

else 
        echo "New file  will be added to  ${out_stat}"
fi

            
###############################################################
###############################################################


if [ ${fileadd} = "yes" ];then

	CONTADOR=1
	CONTADORIF=1
	
	while [  $CONTADOR -lt 100 ];
	do
	        if grep -q file_${CONTADOR} "$pyfile"; then
	                echo File found "file_${CONTADOR}"
	                let CONTADORIF=CONTADORIF+1 
	        fi
	
	        let CONTADOR=CONTADOR+1 
	done
	
	echo "File new: $file_n"
	
	file_n="file_$CONTADORIF"
	
	let CONTADOR=CONTADORIF-1 
	
	file_a="file_$CONTADOR"
	
	#echo "Last File:$file_a "
	
	if  [ -f "${out_stat}/files_${Exp}.tar.gz" ]; then
	
	        echo "Files of the run exits, the file  ${Exp} was updated"
	
	else 
	        #echo ${CONTADOR}
	
	        if [ ${CONTADOR} = 0 ];then
	        
	        	echo -e '#######################################################' > "${pyfile}"
	        	echo -e "#File to define the direction of the ${program} runs."   >> "${pyfile}"
	        	echo -e '#######################################################' >> "${pyfile}"
	        	echo -e '\n'>> "${pyfile}"
	        	echo -e '### My own files'>> "${pyfile}"
	        	echo -e '\n'>> "${pyfile}"
	        	echo -e '##Adress of the computer'>> "${pyfile}"
	        	echo -e 'from     files_direction  import *'>> "${pyfile}"
	        	echo -e '\n'>> "${pyfile}"
	        	echo -e "import   sam_python.var_files.var_to_load_${program} as ${program}" >> "${pyfile}" 
	        	echo -e '\n'>> "${pyfile}"
	        	echo -e '#######################################################' >> "${pyfile}"
	        	echo -e '#Files of SAM to load.' >> "${pyfile}"
	        	echo -e '#######################################################' >> "${pyfile}"
	        fi
	
		echo "New file  added to python scrip: $file_n"
		echo $out_stat/$Exp.nc
		echo -e "\n" >> "$pyfile"
		echo -e "name        = '${exp_name}'">> "$pyfile"  
		echo -e "#note       = $note" >> "$pyfile"
		echo -e "$file_n     = '$out_stat/$Exp.nc'" >> "$pyfile"
		echo -e "var1d       = [${var1d}] "   >> "$pyfile" 
		echo -e "var2d       = [${var2d}] "   >> "$pyfile"
		echo -e "vars_diurnal= [${vars_diurnal}]">> "$pyfile"
		echo -e "date        = [(${di}),(${df})] " >> "$pyfile"
		echo -e "date_diurnal= [(${did}),(${dfd})] " >> "$pyfile"
		echo -e "cal         = ${calendar}" >> "$pyfile"
		echo -e "${exp_name} = ${program}.ncload(name,date,$file_n,cal,var1d,var2d,vars_diurnal,date_diurnal)" >> "$pyfile"
	fi


	
#Copy from the swan
#scp ${swan_out}/files_${Exp}.tar  ${out_stat}/
#swan
#scp ${swan_out}/files_${Exp}.tar.gz  ${out_stat}/
#xc50

HOME1=${out_stat}

scp  ${machine1}:${HOME2}/files_${Exp}.tar.gz ${out_stat}/

#tar -xvf ${out_stat}/files_${Exp}.tar --strip-components 7 -C ${out_stat}/  
tar -xvzf ${out_stat}/files_${Exp}.tar.gz --strip-components ${numberoffolder} -C ${out_stat}/  

mv ${out_stat}/prm_${Exp} ${prmfolder}/prm_${Exp}

echo "The files were copied and extracted in the ${out_stat} folder"

else 
echo "Nothing to do"

fi

