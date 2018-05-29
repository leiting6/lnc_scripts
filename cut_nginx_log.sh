#!/bin/bash
# This script run at 00:00

cur_dir=`pwd`

# The Nginx logs path
logs_path="/data/www2/logs/"
backup_path=${logs_path}$(date -d "yesterday" +"%Y")"/"
if [ ! -d $backup_path ];then
    mkdir $backup_path
fi

access_src_file=${logs_path}research.lexisnexis.com.cn-access_log
error_src_file=${logs_path}research.lexisnexis.com.cn-error_log

access_bak_file=${backup_path}research.lexisnexis.com.cn-access_log.$(date -d "yesterday" +"%Y-%m-%d")
error_bak_file=${backup_path}research.lexisnexis.com.cn-error_log.$(date -d "yesterday" +"%Y-%m-%d")

# lexis api proxy logs
api_proxy_access_src_file=${logs_path}lexisapi_proxy.log
api_proxy_error_src_file=${logs_path}lexisapi_proxy_error.log
# lexis api logs
api_access_src_file=${logs_path}lexisapi.log
api_error_src_file=${logs_path}lexisapi_error.log
# backup file target 
api_proxy_access_bak_file=${backup_path}lexisapi_proxy.log.$(date -d "yesterday" +"%Y-%m-%d")
api_proxy_error_bak_file=${backup_path}lexisapi_proxy_error.log.$(date -d "yesterday" +"%Y-%m-%d")
api_access_bak_file=${backup_path}lexisapi.log.$(date -d "yesterday" +"%Y-%m-%d")
api_error_bak_file=${backup_path}lexisapi_error.log.$(date -d "yesterday" +"%Y-%m-%d")


mv $access_src_file $access_bak_file
mv $error_src_file $error_bak_file
if [ -f "$api_proxy_access_src_file" ]; then
    mv $api_proxy_access_src_file $api_proxy_access_bak_file
fi
if [ -f "$api_proxy_error_src_file" ]; then
    mv $api_proxy_error_src_file $api_proxy_error_bak_file
fi
mv $api_access_src_file $api_access_bak_file
mv $api_error_src_file $api_error_bak_file

#kill -USR1 `cat /usr/local/nginx/nginx.pid`
/etc/init.d/nginx restart

# compress
cd $backup_path
bzip2 $access_bak_file
bzip2 $error_bak_file
if [ -f "$api_proxy_access_bak_file" ]; then
    bzip2 $api_proxy_access_bak_file
fi
if [ -f "$api_proxy_error_bak_file" ]; then
    bzip2 $api_proxy_error_bak_file
fi
bzip2 $api_access_bak_file
bzip2 $api_error_bak_file

cd $cur_dir

