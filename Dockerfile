# Use the official image as a parent image.
FROM ubuntu:latest
# Update and prep
RUN apt-get update && apt-get install -y  wget iproute2 libtinfo5

# Set the working directory.
WORKDIR /appl/arweave

# Clone the arweave Repo
RUN wget https://github.com/ArweaveTeam/arweave/releases/download/N.2.1.0.2/arweave-2.1.0.2.linux-x86_64.tar.gz && tar -zxvf arweave-2.1.0.2.linux-x86_64.tar.gz

WORKDIR /appl/arweave/bin/

CMD [ "/bin/bash", "../erts-10.3.5/bin/epmd -d &" && "/bin/bash", "./start", "data_dir /mnt/arweave-data", "max_miners 0", "peer 159.203.158.108", "peer 138.197.232.192", "peer 134.209.27.233", "peer 167.71.128.173", "peer 134.209.27.239", "peer 209.97.191.10", "peer 46.101.67.172", "requests_per_minute_limit 3000", "disk_space 1000000", "tx_propagation_parallelization 3", "max_emitters 1", "enable arql_tags_index", "port 1984" ]

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 1984

# Run the specified command within the container.
#CMD [ "npm", "start" ]

# Copy the rest of your app's source code from your host to your image filesystem.
#COPY . .

