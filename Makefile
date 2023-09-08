-include .env

build:; forge build  #This line executes the command on the same line

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMeScript --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv 

deploy-fake:
	 forge script script/DeployFundMe.s.sol:DeployFundMeScript $(NETWORK_ARGS)