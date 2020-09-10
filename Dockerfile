 ### ARWEAVE ####
 # file: Dockerfile
# Use the official image as a parent image.
FROM ubuntu:latest
# Update and prep
RUN apt-get -qq update >/dev/null && apt-get -qq install -y wget iproute2 libtinfo5 git >/dev/null

# Set the working directory.
WORKDIR /appl/arweave

# Clone the arweave Repo
RUN wget -q https://github.com/ArweaveTeam/arweave/releases/download/N.2.1.0.2/arweave-2.1.0.2.linux-x86_64.tar.gz && tar -zxf arweave-2.1.0.2.linux-x86_64.tar.gz

WORKDIR /appl/arweave/bin/

RUN git clone -b develop https://github.com/tudorfil9/arweave-node.git /appl/arweave-node && cp /appl/arweave-node/start_w_epmd.sh .

RUN chmod +x start_w_epmd.sh

ENV AR_RUNMODE=${AR_RUNMODE}

ENTRYPOINT [ "./start_w_epmd.sh", "-r $AR_RUNMODE" ]

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 1984


