#!/bin/bash
# 定义初始路径
SCRIPTDIR=${cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd}
# 待执行程序路径
JAR_NAME="${SCRIPTDIR}/auto_start_stop_restart.jar"
# 程序后台运行日志路径
LOG_PATh="${SCRIPTDIR}/auto_start_stop_restart.log"
 
 
# 运行提示
tips() {
	echo "可手动更换待执行程序语言,默认支持java"
	echo "WARNING!!!......Tips, please use command: sh auto_start_stop_restart.sh [start|stop|restart|status].   For example: sh auto_start_stop_restart.sh start  "
	echo ""
	exit 1
}
 
 
# 程序启动部分
start() {
        # 重新获取一下pid，因为其它操作如stop会导致pid的状态更新
	pid=`ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}'`
        # -z 表示如果$pid为空时执行
	if [ -z $pid ]; then
        nohup java -jar $JAR_NAME >> ${SCRIPTDIR}/auto_start_stop_restart.log 2>&1 &
        pid=`ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}'`
		echo ""
        echo "Service ${JAR_NAME} is starting！pid=${pid}"
		echo "........................Here is the log.............................."
		echo "....................................................................."
        tail -f $LOG_PATh
		echo "........................Start successfully！........................."
	else
		echo ""
		echo "Service ${JAR_NAME} is already running,it's pid = ${pid}. If necessary, please use command: sh auto_start_stop_restart.sh restart."
		echo ""
	fi
}
 
# 程序停止部分
stop() {
		# 重新获取一下pid，因为其它操作如start会导致pid的状态更新
	pid=`ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}'`
        # -z 表示如果$pid为空时执行。 注意：每个命令和变量之间一定要前后加空格，否则会提示command找不到
	if [ -z $pid ]; then
		echo ""
        echo "Service ${JAR_NAME} is not running! It's not necessary to stop it!"
		echo ""
	else
		kill -9 $pid
		echo ""
		echo "Service stop successfully！pid:${pid} which has been killed forcibly!"
		echo ""
	fi
}
 
# 程序运行状态
status() {
        # 重新获取一下pid，因为其它操作如stop、restart、start等会导致pid的状态更新
	pid=`ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}'`
        # -z 表示如果$pid为空时执行。注意：每个命令和变量之间一定要前后加空格，否则会提示command找不到
	if [ -z $pid ];then
		echo ""
        echo "Service ${JAR_NAME} is not running!"
		echo ""
	else
		echo ""
        echo "Service ${JAR_NAME} is running. It's pid=${pid}"
		echo ""
	fi
}
 
# 程序重启部分
restart() {
	echo ""
	echo ".............................Restarting.............................."
	echo "....................................................................."
		# 重新获取一下pid，因为其它操作如start会导致pid的状态更新
	pid=`ps -ef | grep $JAR_NAME | grep -v grep | awk '{print $2}'`
        # -z 表示如果$pid为空时执行。 注意：每个命令和变量之间一定要前后加空格，否则会提示command找不到
	if [ ! -z $pid ]; then
		kill -9 $pid
	fi
	start
	echo "....................Restart successfully！..........................."
}
 
# 程序执行功能列表
case "$1" in
   "start")
     start
     ;;
   "stop")
     stop
     ;;
   "status")
     status
     ;;
   "restart")
     restart
     ;;
   *)
     tips
     ;;
esac
