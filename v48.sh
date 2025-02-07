#!/bin/bash
echo "EXECUTOR T3RN"

sleep 1

cd $HOME
rm -rf executor
sleep 1
sudo apt update
sudo apt upgrade

sudo apt-get install figlet
figlet -f /usr/share/figlet/starwars.flf

EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/v0.48.0/executor-linux-v0.48.0.tar.gz"
EXECUTOR_FILE="executor-linux-v0.48.0.tar.gz"

echo "Downloading the Executor binary from $EXECUTOR_URL..."
curl -L -o $EXECUTOR_FILE $EXECUTOR_URL

if [ $? -ne 0 ]; then
    echo "Failed to download the Executor binary. Please check your internet connection and try again."
    exit 1
fi

echo "Extracting the binary..."
tar -xzvf $EXECUTOR_FILE
rm -rf $EXECUTOR_FILE
cd executor/executor/bin

echo "Binary downloaded and extracted successfully."
echo

export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false

export EXECUTOR_MAX_L3_GAS_PRICE=10000

read -p "Enter your Private Key from Metamask: " PRIVATE_KEY_LOCAL
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL
echo -e "\nPrivate key has been set."
echo

export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn'

read -p "KEY ALCHEMY: " KEYALCHEMY

export RPC_ENDPOINTS_ARBT="https://arb-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_BSSP="https://base-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_BLSS="https://blast-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_OPSP="https://opt-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_L1RN='https://brn.rpc.caldera.xyz/'

sleep 2
echo "Starting the Executor..."
./executor
rm -rf t3rn.sh