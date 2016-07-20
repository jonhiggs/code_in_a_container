run: build
	docker run -it \
		-v tmux_sockets:/tmp/tmux-0 \
		--rm \
		--security-opt="seccomp=unconfined" \
		code_in_a_container

build:
	docker build -t code_in_a_container .


volume:
	docker volume create --name tmux_sockets

tmux_new:
	docker run -it \
		-v tmux_sockets:/tmp/tmux-0 \
		--rm \
		--security-opt="seccomp=unconfined" \
		code_in_a_container \
		script -c 'tmux -S /tmp/tmux-0/default new -s shared'

tmux_attach:
	docker run -it \
		-v tmux_sockets:/tmp/tmux-0 \
		--rm \
		--security-opt="seccomp=unconfined" \
		code_in_a_container \
		script -c 'tmux -S /tmp/tmux-0/default attach -t shared'
