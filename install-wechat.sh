#!/usr/bin/env bash

# 启动窗口管理器
bash -c 'nohup /entrypoint.sh 2>&1 &'
sleep 10
sudo netstat -ntlp

## https://gitlab.com/cunidev/gestures/-/wikis/xdotool-list-of-key-codes
function install() {
    while :
    do
        xdotool search '微信安装向导'
        NOTFOUND=$?
        echo $NOTFOUND
        if [ "$NOTFOUND" == "0" ]; then
            echo "微信安装包已打开，等待安装"
            sleep 80
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key space
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Return
            sleep 16
            xdotool key Tab
            sleep 0.5
            xdotool key Tab
            sleep 0.5
            xdotool key Return
            break
        fi
        sleep 5
    done
}

id

wine 'C:\WeChatSetup.exe' &
sudo ps -ef

sleep 1m
install
wait
sleep 10