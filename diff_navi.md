### \[ turns.sh (2014年 11月 28日 星期五 15:24:29 CST)\] ###
*****************************************************************
     getId (){     
     	idx=$1     
     	echo $(awk -v lineNum=$1 '{if (NR == lineNum) {print $0}}' base.ids)     
     }     
          
     diffId() {     
     	clear     
     	lrid=$(getId $1)     
     	echo "Rule Id" $lrid     
     	rulea=$(grep $lrid -A 10 file_a | awk 'BEGIN{space=0}/^\s*$/{exit}{print}')     
     	ruleb=$(grep $lrid -A 10 file_b | awk 'BEGIN{space=0}/^\s*$/{exit}{print}')     
     	echo -e "\e[1;31m"     
     	echo "    [File A]"     
     	echo ""     
     	echo "$rulea"     
     	echo -e "\e[0m"     
     	echo "**************************************************"     
     	echo ""     
     	echo -e "\e[1;32m"     
     	echo "    [File B]"     
     	echo ""     
     	echo "$ruleb"     
     	echo -e "\e[0m"     
     	echo "**************************************************"     
     	echo ""     
     	#vimdiff -c "windo set wrap" <(echo $rulea) <(echo $ruleb)     
     	dwdiff -c -L <(echo $rulea) <(echo $ruleb)     
     	echo ""     
     	echo "**************************************************"     
     	echo ""     
     }     
          
     getCmd (){     
     	read -n 1 c     
     	if [ "$c" == "p" ]     
     	then     
     		echo "prev"     
     	elif [ "$c" == "r" ]     
     	then     
     		echo "reload"     
     	elif [ "$c" != "n" ]     
     	then     
     		echo "exit"     
     	else     
     		echo "next"     
     	fi     
     }     
          
     rulenums=$(wc base.ids | awk '{print $1}')     
          
     rid=1     
          
     while (( $rid <= $rulenums ))     
     do     
     	# Show current diff     
     	echo $rid     
     	diffId $rid     
          
     	# Process command     
     	cmd=$(getCmd)     
          
     	if [ "$cmd" == "next" ]     
     	then      
     		rid=$(( rid + 1 ))     
     	elif [ "$cmd" == "prev" ]     
     	then     
     		rid=$(( rid <= 1 ? 1: rid - 1 ))     
     	elif [ "$cmd" == "exit" ]     
     	then     
     		exit     
     	fi     
     done     
          
     exit     
*****************************************************************
