FROM lxh01/wine-vnc:latest

# 清理环境
RUN sudo rm -rf /tmp/.X0-lock

ENV WINEDEBUG=fixme-all

# 根据传入参数安装微信和wxhelper.dll
ARG WECHAT_URL=https://github.com/tom-snow/wechat-windows-versions/releases/download/v3.9.5.81/WeChatSetup-3.9.5.81.exe
ARG WXHELPER_URL=https://github.com/ttttupup/wxhelper/releases/download/3.9.5.81-v11/wxhelper.dll

WORKDIR /home/app/.wine/drive_c

# 补充Windows字体
COPY ./Fonts ./windows/Fonts

# 加载注入器
ADD https://github.com/furacas/DllInjector/releases/download/v1.4.0/DllInjector64.exe DllInjector.exe
RUN sudo chown app:app DllInjector.exe && sudo chmod a+x DllInjector.exe

# 下载微信
ADD ${WECHAT_URL} WeChatSetup.exe
RUN sudo chown app:app WeChatSetup.exe  && sudo chmod a+x WeChatSetup.exe

# 下载wxhelper.dll
ADD ${WXHELPER_URL} wxhelper.dll
RUN sudo chown app:app wxhelper.dll

RUN ls -lah

# 安装微信
COPY install-wechat.sh install-wechat.sh
RUN bash -c 'nohup /entrypoint.sh 2>&1 &' && sleep 10 && sudo netstat -ntlp
RUN bash -c 'wine WeChatSetup.exe &'
RUN bash -c 'sudo ps -ef'
RUN sudo chmod a+x install-wechat.sh && ./install-wechat.sh
RUN rm -rf WeChatSetup.exe && rm -rf install-wechat.sh

EXPOSE 5900 19088

COPY cmd.sh /cmd.sh
CMD ["/cmd.sh"]