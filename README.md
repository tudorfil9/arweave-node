### ARWEAVE ####
# file: README.md
# ARWEAVE NODE

----
## Building the image for DEPLOYMENT


1. Run `docker-compose build --run -e "-runmode=test"`
2. Wait for the image to be built

## Running the deployed image

The image takes the following arguments:

- `RUNMODE` (only works running with docker-compose) the runmode [test|node|miner] 

## RUNMODE
- `test`    - this option sets the node to benchmark mode for hashrate    calculations.
- `node`    - this option configures the node for gateway mode, no mining
- `miner`   - default miner role
