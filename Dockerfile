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
RUN echo '#!/bin/bash' >> /system_info.sh
RUN echo 'echo "System information as of $(date)"' >> /system_info.sh
RUN echo 'echo "  System load:              $(uptime | awk '\''{print $10}'\'')" >> /system_info.sh
RUN echo 'echo "  Usage of /:               $(df -h / | awk '\''NR==2 {print $5}'\'')" >> /system_info.sh
RUN echo 'echo "  Memory usage:             $(free -m | awk '\''NR==2 {print $3/$2 * 100}'\'')%"' >> /system_info.sh
RUN echo 'echo "  Swap usage:               $(free -m | awk '\''NR==4 {print $3/$2 * 100}'\'')%"' >> /system_info.sh
RUN echo 'echo "  Processes:                $(ps aux | wc -l)"' >> /system_info.sh
RUN echo 'echo "  Users logged in:          $(who | wc -l)"' >> /system_info.sh
RUN echo 'echo "  IPv4 address for docker0: $(ip addr show docker0 | grep '\''inet'\'' | awk '\''{print $2}'\'')" >> /system_info.sh
RUN echo 'echo "  IPv4 address for enp1s0:  $(ip addr show enp1s0 | grep '\''inet'\'' | awk '\''{print $2}'\'')" >> /system_info.sh
RUN echo 'echo "  IPv6 address for enp1s0:  $(ip addr show enp1s0 | grep '\''inet6'\'' | awk '\''{print $2}'\'')" >> /system_info.sh
RUN chmod +x /system_info.sh
RUN echo 'PS1="root@safonevps \$ "' >> /root/.bashrc
RUN echo '[ -n "$SSH_CONNECTION" ] && /system_info.sh' >> /root/.bashrc

COPY . .

EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

CMD ["bash", "start.sh"]
