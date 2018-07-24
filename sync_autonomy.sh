#!/usr/bin/env bash

# step1, 211 execute script
_del_old_211autom() {
  cd /usr/local/IDOLServer-10.8.0/dah8 && [ /bin/echo -e "\n" | sudo ./stop.sh ]
  cd /usr/local/IDOLServer-10.8.0/dah5004 && [ /bin/echo -e "\n" | sudo ./stop.sh ]
  cd /usr/local/IDOLServer-10.8.0/dahmain && [ /bin/echo -e "\n" | sudo ./stop.sh ]
  
  ps -ef | grep dah | grep -v grep
  if [ $? == 0 ];then
    for p1 in `ps -ef | grep dah | grep -v grep | awk '{print $2}'`;do
	  kill -9 $p1
	done
  fi
  
  cd /usr/local/IDOLServer-10.8.0 && for t in `seq 1 12`;do [ /bin/echo -e "\n" | sudo ./stop.sh ] && sleep 1;done
  ps -ef | grep content | grep -v grep
  if [ $? != 0 ];then
    for p2 in `ps -ef | grep content | grep -v grep | awk '{print $2}'`;do
	  kill $p2
	done
  fi
  
  cd /usr/local/IDOLServer-10.8.0 && rm -rf content.* && echo "211 autonomy's content has cleared ...."
}


# step2, stop autonomy of 30
_stop_dah_cont() {
  cd /usr/local/IDOLServer-10.8.0/dah8 && [ /bin/echo -e "\n" | sudo ./stop.sh ]
  ps -ef | grep dah | grep -v grep
  if [ $? != 0 ];then
    for p1 in `ps -ef | grep dah | grep -v grep | awk '{print $2}'`;do
	  kill $p1
	done
  fi
	
  cd /usr/local/IDOLServer-10.8.0 && for t in `seq 1 12`;do [ /bin/echo -e "\n" | sudo ./stop.sh ] && sleep 1;done
  ps -ef | grep content | grep -v grep
  if [ $? != 0 ];then
    for p2 in `ps -ef | grep content | grep -v grep | awk '{print $2}'`;do
	  kill $p2
	done
  fi
  
  echo "30 dah and content has stopped of autonomy ....."
}

# step3, sync autonomy's content from 30 to 211
_sync_30content() {
  cd /usr/local/IDOLServer-10.8.0 && scp -r ./content.[1-9] root@192.168.2.211:/usr/local/IDOLServer-10.8.0/ && scp -r ./content.1[0-2] root@192.168.2.211:/usr/local/IDOLServer-10.8.0/ && echo "sync autonomy's content from 30 to 211 has finished ...."
  cd /usr/local/IDOLServer-10.8.0 && for t in `seq 1 12`;do [ /bin/echo -e "\n" | sudo ./start.sh ] ;done && ps -ef | grep content | grep -v grep | wc -l  
  cd /usr/local/IDOLServer-10.8.0/dah8 && [ /bin/echo -e "\n" | sudo ./start.sh ] && ps -ef | grep dah | grep -v grep
}

# step4, 211 execute script
_start_211autom() {
  cd /usr/local/IDOLServer-10.8.0 && rm -rf content.[1-9]/logs/*.zip &&  rm -rf content.1[0-2]/logs/*.zip
  
  cd /usr/local/IDOLServer-10.8.0 && for t in `seq 1 12`;do [ /bin/echo -e "\n" | sudo ./start.sh ] ;done && ps -ef | grep content | grep -v grep | wc -l  
  cd /usr/local/IDOLServer-10.8.0/dah8 && [ /bin/echo -e "\n" | sudo ./start.sh ] && ps -ef | grep dah | grep -v grep
  cd /usr/local/IDOLServer-10.8.0/dahmain && [ /bin/echo -e "\n" | sudo ./start.sh ] && ps -ef | grep dah | grep -v grep
  cd /usr/local/IDOLServer-10.8.0/dah5004 && [ /bin/echo -e "\n" | sudo ./start.sh ] && ps -ef | grep dah | grep -v grep
}
