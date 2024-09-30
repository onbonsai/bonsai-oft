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
forge create contracts/BonsaiOFT.sol:BonsaiOFT --account myKeystore --rpc-url zksync-sepolia --chain 300 --zksync --constructor-args 100000 "0xe2Ef622A13e71D9Dd2BBd12cd4b27e1516FA8a09" "0x21af1185734d213d45c6236146fb81e2b0e8b821" --verify
```

Manually save the deployed contract address in `addresses.json`

And send the `setBaseURI` tx
```bash
cast send 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82 "setBaseURI(string)" "ipfs://bafybeiba7hsqirohcgqibxokpml7eoh65z7fagah7ed7ggejud265ro2ky/" --account myKeystore --rpc-url zksync-sepolia --chain 300
```

### Wire the mesh
We need to set the peers on all contracts, and set `enforcedOptions` for the Stargate listing requirement. Everything is configured in `*.layerzero.config.ts`
```bash
yarn wire:testnet
```

### Bridge from polygon to zksync/base
then, check the tx on layerzeroscan: https://testnet.layerzeroscan.com
```bash
forge script script/testnet/Bridge.s.sol:LzSendPolygon --rpc-url amoy-testnet -vvvv
```

### Read from BonsaiOFT on base
```bash
forge script script/testnet/Read.s.sol:Read --rpc-url base-sepolia -vvvv
```

### Read from BonsaiOFT on zksync
```bash
zksync-cli contract read --chain "zksync-sepolia" --contract "0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82" --method "mirror()" --output "address"
```

### Verify BonsaiOFT on base
```bash
npx hardhat verify --network base-sepolia --constructor-args ./utils/verify/bonsaiOFT.ts 0x3d2bD0e15829AA5C362a4144FdF4A1112fa29B5c
```

### [TODO] Verify BonsaiOFT on zksync (etherscan)
`Fail - Unable to verify. Compiled contract runtime bytecode does NOT match the on-chain runtime bytecode.`
```
forge verify-contract 0xe86B6e5381C2641c2dfA247628481f1dEd18DCC7 contracts/BonsaiOFT.sol:BonsaiOFT --chain-id 300 --watch --zksync --constructor-args $(cast abi-encode "constructor(uint96,address,address)" 100000 "0xe2Ef622A13e71D9Dd2BBd12cd4b27e1516FA8a09" "0x21af1185734d213d45c6236146fb81e2b0e8b821")
```