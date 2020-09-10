 ### ARWEAVE ####
 # file: Dockerfile
# Use the official image as a parent image.
FROM ubuntu:latest
# Update and prep
RUN apt-get update && apt-get install -y  wget iproute2 libtinfo5 git

# Set the working directory.
WORKDIR /appl/arweave

# Clone the arweave Repo
RUN wget https://github.com/ArweaveTeam/arweave/releases/download/N.2.1.0.2/arweave-2.1.0.2.linux-x86_64.tar.gz && tar -zxvf arweave-2.1.0.2.linux-x86_64.tar.gz

WORKDIR /appl/arweave/bin/

RUN git clone -b develop https://github.com/tudorfil9/arweave-node.git /appl/arweave-node && cp /appl/arweave-node/start_w_epmd.sh .

ENTRYPOINT chmod +x ./start_w_epmd.sh && ./start_w_epmd.sh 

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 1984


