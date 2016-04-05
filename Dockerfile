FROM drydock/u14all:prod

ADD . /u14php7all

RUN /u14php7all/install.sh
