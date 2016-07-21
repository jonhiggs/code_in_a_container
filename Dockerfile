FROM debian:jessie

ENV USER=jon
ENV HOME=/home/${USER}

RUN apt-get update
RUN apt-get update && apt-get -y install tmux git tig wget curl vim

RUN mkdir -p ${HOME}
RUN groupadd ${USER}
RUN useradd -d ${HOME} -g ${USER} ${USER}
RUN chown -R ${USER}:${USER} ${HOME}

USER ${USER}
WORKDIR ${HOME}

RUN mkdir ${HOME}/etc/
RUN mkdir ${HOME}/bin/

# bash_environment
RUN wget https://raw.githubusercontent.com/jonhiggs/bash_environment/master/bin/bash_environment -O ${HOME}/bin/bash_environment
RUN chmod +x ${HOME}/bin/bash_environment

RUN git clone https://github.com/jonhiggs/dotfiles ${HOME}/etc/dotfiles
RUN git clone https://github.com/jonhiggs/tmuxfiles ${HOME}/etc/tmuxfiles

RUN for f in ${HOME}/etc/dotfiles/.bash*; do ln -s $f ${HOME}/$(basename $f); done
RUN ln -s ${HOME}/etc/tmuxfiles/tmux.conf ${HOME}/.tmux.conf

CMD [ "/bin/bash" ]
