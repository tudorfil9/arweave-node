### ARWEAVE ####
# file: README.md
# ARWEAVE NODE

----
## Building the image for DEPLOYMENT


1. Run `docker-compose build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"`
2. Wait for the image to be built
3. Run `docker-compose up -d`


## Running the deployed image

The image takes the following arguments:

- `RUNMODE` (only works running with docker-compose) the runmode [test|node|miner] 

## RUNMODE
- `test`    - this option sets the node to benchmark mode for hashrate    calculations.
- `node`    - this option configures the node for gateway mode, no mining
- `miner`   - default miner role
