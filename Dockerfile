FROM debian:jessie

RUN apt-get update
RUN apt-get update && apt-get -y install tmux
RUN apt-get update && apt-get -y install strace

CMD [ "/bin/bash" ]
