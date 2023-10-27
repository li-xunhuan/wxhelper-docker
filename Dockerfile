FROM furacas/wine-vnc-box:latest

WORKDIR /home/app/.wine/drive_c

ADD https://github.com/furacas/DllInjector/releases/download/v1.4.0/DllInjector64.exe DllInjector.exe

RUN sudo chown app:app DllInjector.exe

ADD https://github.com/tom-snow/wechat-windows-versions/releases/download/v3.9.5.81/WeChatSetup-3.9.5.81.exe WeChatSetup.exe

COPY install-wechat.sh install-wechat.sh

RUN bash -c 'nohup /entrypoint.sh 2>&1 &' && \
    sleep 10 && \
    sudo chown app:app WeChatSetup.exe && \
     ./install-wechat.sh && \
     rm -rf WeChatSetup.exe && \
     rm -rf install-wechat.sh


ADD https://github.com/ttttupup/wxhelper/releases/download/3.9.5.81-v10/wxhelper.dll wxhelper.dll

RUN sudo chown app:app wxhelper.dll


COPY cmd.sh /cmd.sh


CMD ["/cmd.sh"]


