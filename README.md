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

## Build the contracts
```bash
pnpm compile
```

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

```bash
pnpm compile:forge:zksync
forge create contracts/BonsaiOFT.sol:BonsaiOFT --account myKeystore --rpc-url zksync --chain 324 --zksync --constructor-args 100000 "0xd07C30aF3Ff30D96BDc9c6044958230Eb797DDBF" "0x21aF1185734D213D45C6236146fb81E2b0E8b821" --verify
```

Manually save the deployed contract address in `addresses.json`

And send the `setBaseURI` tx
```bash
cast send 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82 "setBaseURI(string)" "ipfs://bafybeiba7hsqirohcgqibxokpml7eoh65z7fagah7ed7ggejud265ro2ky/" --account myKeystore --rpc-url zksync --chain 324
```

### Wire the mesh
We need to set the peers on all contracts, and set `enforcedOptions` for the Stargate listing requirement. Everything is configured in `*.layerzero.config.ts`
https://docs.layerzero.network/v2/developers/evm/technical-reference/dvn-addresses
https://docs.layerzero.network/v2/developers/evm/technical-reference/deployed-contracts
```bash
yarn wire
```

### Bridge from polygon to zksync/base/lens
then, check the tx on layerzeroscan: https://layerzeroscan.com
```bash
forge script script/mainnet/Bridge.s.sol:LzSendPolygon --rpc-url polygon -vvvv --broadcast
```

### Bridge from base to zksync
then, check the tx on layerzeroscan: https://layerzeroscan.com
```bash
forge script script/mainnet/Bridge.s.sol:LzSendBase --rpc-url base -vvvv --broadcast
```

### Bridge from zksync to base
then, check the tx on layerzeroscan: https://layerzeroscan.com
```bash
forge script script/mainnet/Bridge.s.sol:LzSendZkSync --rpc-url zksync -vvvv --broadcast
```

### Read from BonsaiOFT on base
```bash
forge script script/mainnet/Read.s.sol:Read --rpc-url base -vvvv
```

### Read from BonsaiOFT on zksync
```bash
zksync-cli contract read --chain "zksync" --contract "0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82" --method "mirror()" --output "address"
```

### Verify BonsaiOFTAdapter on polygon
```bash
npx hardhat verify --network polygon --constructor-args ./utils/verify/bonsaiOFTAdapter.ts 0x303b63e785B656ca56ea5A5C1634Ab20C98895e1
```

### Verify BonsaiOFT on base
```bash
npx hardhat verify --network base --constructor-args ./utils/verify/bonsaiOFT.ts 0x474f4cb764df9da079D94052fED39625c147C12C
```

### [TODO] Verify BonsaiOFT on zksync (etherscan)
`Fail - Unable to verify. Compiled contract runtime bytecode does NOT match the on-chain runtime bytecode.`
```
forge verify-contract 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82 contracts/BonsaiOFT.sol:BonsaiOFT --chain-id 324 --watch --zksync --constructor-args $(cast abi-encode "constructor(uint96,address,address)" 100000 "0xd07C30aF3Ff30D96BDc9c6044958230Eb797DDBF" "0x21af1185734d213d45c6236146fb81e2b0e8b821")
```