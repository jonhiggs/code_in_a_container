FROM debian:jessie

ENV USER=jon
ENV HOME=/home/${USER}

RUN apt-get update && apt-get -y install tmux git tig wget curl vim sudo

RUN mkdir -p ${HOME}
RUN groupadd ${USER}
RUN useradd -d ${HOME} -g ${USER} -G sudo ${USER}
RUN chown -R ${USER}:${USER} ${HOME}
RUN sed -i -E "s/^%sudo.*/%sudo ALL=NOPASSWD: ALL/" /etc/sudoers

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

USER root
WORKDIR /usr/local/src/
RUN git clone https://github.com/neovim/neovim
RUN apt-get -y install build-essential
WORKDIR /usr/local/src/neovim
ENV neovim_release=v0.1.4
RUN git checkout ${neovim_release}
RUN apt-get -y install cmake
RUN apt-get -y install pkg-config
RUN apt-get -y install libtool-bin
RUN apt-get -y install automake
RUN apt-get -y install unzip
RUN make

USER ${USER}
WORKDIR ${HOME}
RUN git clone https://github.com/jonhiggs/vimfiles ${HOME}/etc/vimfiles

CMD [ "/bin/bash" ]
