  ### ARWEAVE ####
 # file: start_w_epmd.sh
 #!/bin/bash


while getopts r: flag
	do
	    case "${flag}" in
	        r) runmode=${OPTARG};;
	    esac
	done
	echo "runmode: $runmode";

case $runmode in
		test)
			echo "selected TEST"
			../erts-10.3.5/bin/epmd -daemon && \
			/bin/bash ./start-server
			;;
		*)
            echo $"Usage: $0 {test|node|miner}"
            exit 1
esac
# ../erts-10.3.5/bin/epmd -daemon && \
# /bin/bash ./start data_dir /mnt/arweave-data \
#                     max_miners 0 \
#                     peer 159.203.158.108 \
#                     peer 138.197.232.192 \
#                     peer 134.209.27.233 \
#                     peer 167.71.128.173 \
#                     peer 134.209.27.239 \
#                     peer 209.97.191.10 \
#                     peer 46.101.67.172 \
#                     requests_per_minute_limit 3000 \
#                     disk_space 1000000 \
#                     tx_propagation_parallelization 3 \
#                     max_emitters 1 \
#                     enable arql_tags_index \
#                     port 1984