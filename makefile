create-image:
	clear
	docker build -t myimage .

create-volume:
	clear
	docker volume create myvolume

run-image:
	clear
	docker run --rm -it -e DISPLAY=host.docker.internal:0 -e QT_X11_NO_MITSHM=1 --volume myvolume:/root/catkinws myimage