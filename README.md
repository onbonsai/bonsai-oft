# bonsai-oft
deployment of BonsaiOFT to zksync, base, and the BonsaiOFTAdapter to polygon

## pre-requisites
this repo was created using the zksync-cli: https://docs.zksync.io/build/zksync-cli

to build the contracts for zksync era, we use foundry-zksync: https://docs.zksync.io/build/tooling/foundry/overview

## Deploying Contracts

Set up deployer wallet/account:

- Rename `.env.example` -> `.env`
- Set private key for both formats
- Fund this address with the corresponding chain's native tokens you want to deploy to.

We're going to deploy
- `BonsaiOFTAdapter` to polygon
- `BonsaiOFT` to Base (with cli)
- `BonsaiOFT` to zkSync Era (with foundry)

All scripts set the base uri to the current NFT uri; No initial supply is set for BonsaiOFT contracts on Base/zkSync

### Deploy `BonsaiOFTAdapter` to Polygon
Toggle only the polygon network with [SPACE] and set the tag as `BonsaiOFTAdapter`
```bash
npx hardhat lz:deploy
```

### Deploy `BonsaiOFT` to Base
Toggle only the base network with [SPACE] and set the tag as `BonsaiOFT`
```bash
npx hardhat lz:deploy
```

### Deploy `BonsaiOFT` to zkSync
Read: https://docs.zksync.io/build/tooling/foundry/getting-started#deploying-smart-contracts-with-forge

To deploy to zksync, use `foundry create`

`zksync-testnet`
```bash
pnpm compile:forge:zksync
forge script script/testnet/Deploy.s.sol:DeployBonsaiOFT --rpc-url zksync-sepolia -vvvv
forge create contracts/BonsaiOFT.sol:BonsaiOFT --account myKeystore --rpc-url zksync-sepolia --chain 300 --zksync --constructor-args 100000 "0xe2Ef622A13e71D9Dd2BBd12cd4b27e1516FA8a09" "0x21af1185734d213d45c6236146fb81e2b0e8b821"
```

Manually save the deployed contract address in `addresses.json`

And send the `setBaseURI` tx
```bash
cast send 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82 "setBaseURI(string)" "ipfs://bafybeiba7hsqirohcgqibxokpml7eoh65z7fagah7ed7ggejud265ro2ky/" --account myKeystore --rpc-url zksync-sepolia --chain 300
```