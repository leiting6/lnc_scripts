#!/bin/bash
#######################################################
# $Name:         increment_table_db.sh
# $Version:      v1.0
# $Function:     update from prd table db to test tables db
# $Author:       Leiting Liu
# $organization: leiting.liu@lexisnexis.com
# $Create Date:  2017-11-15
# $Description:  You know what i mean,hehe
#######################################################
#read -p "Please input a Production's DB name. : " PRD_DB
#read -p "Please input a Producation's Table name. : " PRD_TABLE
#read -p "Please input a Production's query condition for increment tables DB, such as, ['id > 2']. : " PRD_WHERE
#echo "$PRD_DB,$PRD_TABLE,$PRD_WHERE"

##judge output's table file
if [ -f /tmp/$2.sql ];then
  sudo rm -rf /tmp/$2.sql
fi

if [ $1 == "history" ] || [ $1 == "newlaw" ] || [ $1 == "lnc" ] || [ $1 == "pgportal" ];then
  if [[ ${2:0:7}* == "ex_news*" ]] || [[ ${2:0:12}* == "lnc_category*" ]] || [[ ${2:0:11}* == "tax_content*" ]] || [[ ${2:0:8}* == "add_mail*" ]];then
    if [ "$3" == 1 ];then
      mysqldump -uprcinvestment -pPW -h 192.168.2.211 --default-character-set=gbk --no-create-info --databases $1 --tables $2 --where="$3" > /tmp/$2.sql && mysql -uprcinvestment -pPW -h $4 $5 -e "truncate $2;source /tmp/$2.sql;" && echo "This a full TABLE: '$2' updated for test's DB NAME: '$5'."
    else
      mysqldump -uprcinvestment -pPW -h 192.168.2.211 --default-character-set=gbk --no-create-info --databases $1 --tables $2 --where="$3" > /tmp/$2.sql && mysql -uprcinvestment -pPW -h $4 $5 -e "delete from $2 where $3;source /tmp/$2.sql;"
      echo "This is a increment tables update."
    fi  
  else
    echo -e "\033[41m The table NAME: '$2' can not query or output.\033[0m"
    exit 5
  fi  
else
  echo -e "\033[41m DB NAME: '$1' is not exist.\033[0m"
fi
