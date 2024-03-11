## 自动注入`wxhelper`的微信PC版镜像

## 免责声明

本仓库发布的内容，仅用于学习研究，请勿用于非法用途和商业用途！如因此产生任何法律纠纷，均与作者无关！  
使用此项目可能会造成封号等后果。请自行承担风险。仅用于学习研究，请勿于非法用途。

## 注意事项

1. 只支持`x86`架构
2. 宿主机系统发行版限制`Debian`系（非`Debian`系需要关闭`seccomp`）
3. `VNC`页面切记不要手贱关闭微信窗口，否则只能重启容器
4. `VNC`页面字体乱码是正常的，不影响接口使用

## 端口

1. `5900`端口，`VNC`服务的端口，需要用`VNC Viewer`之类的工具连接打开。
2. `8080`端口(`tag`带`novnc`的镜像专属)，`noVNC`网页端口，可在浏览器打开。
3. `19088`端口，`wxhelper`接口

## 使用方式

```yaml
version: '3'

services:
  wechat:
    image: lxh01/wxhelper-docker:{tag} # 自行选择喜欢的tag
    container_name: wechat
    restart: unless-stopped
    # 关闭seccomp，在非debian系宿主机运行时需要取消掉下面这两行注释
    #security_opt:
    #  - seccomp:unconfined
    environment:
      - WINEDEBUG=fixme-all
    volumes:
      - ./data/wechat:/home/app/.wine/drive_c/users/app/Documents/WeChat\ Files # 映射微信缓存目录
    ports:
      - "5900:5900" # VNC接口，使用VNC Viewer连接之后可以扫码登录微信
      - "8080:8080" # noVNC端口，仅tag含有novnc才有这个
      - "19088:19088" # wxhelper的接口端口
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:19088/api/checkLogin"]
      interval: 60s
      timeout: 10s
      retries: 5
```

## 鸣谢

[wxhelper](https://github.com/ttttupup/wxhelper)  
[wxhelper-docker](https://github.com/thinker007/wxhelper-docker)
