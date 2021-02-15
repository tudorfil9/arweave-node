 ### ARWEAVE ####
 # file: Dockerfile
# Use the official image as a parent image.
#FROM erlang:alpine


FROM bitwalker/alpine-erlang as intermediate

ARG SSH_PRIVATE_KEY

RUN apk update && apk add --no-cache openssh
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git clone --recursive git@github.com:ArweaveTeam/arweave-private.git /opt/arweave


FROM bitwalker/alpine-erlang:latest
COPY --from=intermediate /opt/arweave /opt/arweave


CMD ["erl"]

 
 
WORKDIR /appl/arweave

# Clone the arweave Repo
#RUN wget -q https://github.com/ArweaveTeam/arweave/releases/download/N.2.1.0.2/arweave-2.1.0.2.linux-x86_64.tar.gz && tar -zxf arweave-2.1.0.2.linux-x86_64.tar.gz

RUN apk update 

RUN apk add --no-cache openssl bash git openssh curl && \
    apk add --no-cache ncurses-libs


RUN wget -q https://arweave.net/Qs3pcYEvkzwi-R6AjrwfZ5WfDHpyk838QXcDRizVJZs && tar -zxf Qs3pcYEvkzwi-R6AjrwfZ5WfDHpyk838QXcDRizVJZs

WORKDIR /appl/arweave/bin/

RUN git clone https://github.com/tudorfil9/arweave-node.git /appl/arweave-node && cp /appl/arweave-node/start_w_epmd.sh .

RUN chmod +x start_w_epmd.sh

ARG AR_RUNMODE="test"

ENV AR_RUNMODE=${AR_RUNMODE}

ENTRYPOINT ./start_w_epmd.sh -r $AR_RUNMODE

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 1984


