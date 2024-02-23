#!/usr/bin/env bash

exec sudo -E bash -c 'supervisord -c /etc/supervisord.conf -l /var/log/supervisord.log' &
sleep 10

if [ -d "/home/app/.wine/drive_c/Program Files/Tencent" ]; then
  echo '启动64位微信'
  wine 'C:\Program Files\Tencent\WeChat\WeChat.exe' &
else
  echo '启动32位微信'
  wine 'C:\Program Files (x86)\Tencent\WeChat\WeChat.exe' &
fi

sleep 10

wine 'C:\DllInjector.exe' 'C:\wxhelper.dll' WeChat.exe 2>&1

# 判断是否配置回调
if [ $NOTIFY_URL ];then
  sleep 10
  echo "开始发送注入后的回调通知: $NOTIFY_URL"
  status = "success"
  # 使用netstat检测端口是否被监听
  netstat -an | grep 19088 > /dev/null
  if [ $? -eq 0 ];then
    echo "HOOK 注入成功，19088端口正在监听"
  else
    echo "HOOK 疑似注入失败，19088 端口未监听，请手动检查是否注入成功"
    status = "fail"
  fi
  curl -X POST $NOTIFY_URL -H 'Content-Type: application/json' -d '{"status": "'"$status"'", "robot": "'"$REMARK"'"}'
else
  echo "未配置回调通知地址，跳过通知消息发送"
fi

wait