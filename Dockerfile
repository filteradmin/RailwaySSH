FROM ubuntu:latest

RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
ARG ngrokid=2TKpUVMArM3l4uRQndjgYEQAO5l_2TVpECASVAehd2yJurYwb
ARG Password=safone@1
ENV Password=${Password}
ENV ngrokid=${ngrokid}

RUN apt install ssh git wget curl nano htop zip unzip rar unrar tar screen ffmpeg neofetch p7zip-full python3-pip -y > /dev/null 2>&1
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${ngrokid} &&" >>/1.sh
RUN echo "./ngrok tcp 22 &>/dev/null &" >>/1.sh
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/1.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:${Password}|chpasswd
RUN service ssh start
RUN chmod 755 /1.sh

RUN pip3 install flask flask_restful
RUN echo 'PS1="root@safonevps:~# "' >> /root/.bashrc
RUN echo 'echo ""' >> /root/.bashrc
RUN echo 'echo "   _____         ______    ____  _   _ ______ "' >> /root/.bashrc
RUN echo 'echo "  / ____|  /\   |  ____|  / __ \| \ | |  ____|"' >> /root/.bashrc
RUN echo 'echo " | (___   /  \  | |__    | |  | |  \| | |__   "' >> /root/.bashrc
RUN echo 'echo "  \___ \ / /\ \ |  __|   | |  | | . ` |  __|  "' >> /root/.bashrc
RUN echo 'echo "  ____) / ____ \| |      | |__| | |\  | |____ "' >> /root/.bashrc
RUN echo 'echo " |_____/_/    \_\_|       \____/|_| \_|______|"' >> /root/.bashrc
RUN echo 'echo "                                              "' >> /root/.bashrc
RUN echo 'echo ""' >> /root/.bashrc
RUN echo 'echo "This server is hosted by Safone. If you have any questions or need help,"' >> /root/.bashrc
RUN echo 'echo "please don\'t hesitate to contact us at support@safone.dev."' >> /root/.bashrc
RUN echo 'echo ""' >> /root/.bashrc

COPY . .

EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

CMD ["bash", "start.sh"]
