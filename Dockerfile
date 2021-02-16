 ### ARWEAVE ####
 # file: Dockerfile
# Use the official image as a parent image.
#FROM erlang:alpine


# FROM bitwalker/alpine-erlang as intermediate
FROM ubuntu:20.04 as intermediate

ARG SSH_PRIVATE_KEY

# RUN apk update && apk add --no-cache openssh
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt install tzdata -y
RUN apt install -y openssh-server curl git 
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git clone --recursive git@github.com:ArweaveTeam/arweave-private.git /opt/arweave


# FROM bitwalker/alpine-erlang:latest
FROM ubuntu:20.04
COPY --from=intermediate /opt/arweave /opt/arweave
RUN DEBIAN_FRONTEND="noninteractive" apt install tzdata -y
CMD ["erl"]
RUN mkdir /opt/arweave
WORKDIR /opt/arweave

# Clone the arweave Repo
#RUN wget -q https://github.com/ArweaveTeam/arweave/releases/download/N.2.1.0.2/arweave-2.1.0.2.linux-x86_64.tar.gz && tar -zxf arweave-2.1.0.2.linux-x86_64.tar.gz


RUN rm -rf /var/lib/apt/lists/*
RUN apt update
RUN apt install -y openssh-server curl git wget

RUN wget -q https://arweave.net/Qs3pcYEvkzwi-R6AjrwfZ5WfDHpyk838QXcDRizVJZs && tar -zxf Qs3pcYEvkzwi-R6AjrwfZ5WfDHpyk838QXcDRizVJZs -C /opt/arweave/

WORKDIR /opt/arweave/bin/

RUN git clone https://github.com/tudorfil9/arweave-node.git /opt/arweave/ && cp /opt/arweave/bin/start_w_epmd.sh .

RUN chmod +x start_w_epmd.sh

ARG AR_RUNMODE="test"

ENV AR_RUNMODE=${AR_RUNMODE}

ENTRYPOINT ./start_w_epmd.sh -r $AR_RUNMODE

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 1984


