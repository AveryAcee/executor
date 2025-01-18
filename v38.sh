#!/bin/bash

echo "EXECUTOR T3RN"

sleep 1

cd $HOME
rm -rf executor
sleep 1
sudo apt update
sudo apt upgrade -y

EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/v0.38.0/executor-linux-v0.38.0.tar.gz"
EXECUTOR_FILE="executor-linux-v0.38.0.tar.gz"

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

export NODE_ENV=testnet

export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true

# Prompt user for EXECUTOR_MAX_L3_GAS_PRICE
read -p "Enter the maximum L3 gas price (EXECUTOR_MAX_L3_GAS_PRICE): " EXECUTOR_MAX_L3_GAS_PRICE
export EXECUTOR_MAX_L3_GAS_PRICE=$EXECUTOR_MAX_L3_GAS_PRICE

echo -e "EXECUTOR_MAX_L3_GAS_PRICE set to $EXECUTOR_MAX_L3_GAS_PRICE."
echo

export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false

# Prompt user for PRIVATE_KEY_LOCAL
read -p "Enter your Private Key from Metamask: " PRIVATE_KEY_LOCAL
export PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL
echo -e "\nPrivate key has been set."
echo

export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn'

# Prompt user for KEY ALCHEMY
read -p "Enter your Alchemy API Key (KEY ALCHEMY): " KEYALCHEMY

export RPC_ENDPOINTS_ARBT="https://arb-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_BSSP="https://base-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_BLSS="https://blast-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_OPSP="https://opt-sepolia.g.alchemy.com/v2/$KEYALCHEMY"
export RPC_ENDPOINTS_L1RN='https://brn.calderarpc.com/'

sleep 2
echo "Starting the Executor..."
./executor

rm -rf t3rn.sh
