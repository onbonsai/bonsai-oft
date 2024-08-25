import assert from 'assert'

import { type DeployFunction } from 'hardhat-deploy/types'
import getContract from './utils/getContract'

const contractName = 'BonsaiOFT'
const EndpointV2_BASE_SEPOLIA = '0x6EDCE65403992e310A62460808c4b910D972f10f'

const TOKENS_PER_NFT = 100_000

// WITH ART
const URI = 'ipfs://bafybeiba7hsqirohcgqibxokpml7eoh65z7fagah7ed7ggejud265ro2ky/'

const deploy: DeployFunction = async (hre) => {
    const { getNamedAccounts, deployments, ethers, network } = hre

    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()
    const [deployerSigner] = await ethers.getSigners();

    assert(deployer, 'Missing named deployer account')

    console.log(`Network: ${hre.network.name}`)
    console.log(`Deployer: ${deployer}`)

    // This is an external deployment pulled in from @layerzerolabs/lz-evm-sdk-v2
    //
    // @layerzerolabs/toolbox-hardhat takes care of plugging in the external deployments
    // from @layerzerolabs packages based on the configuration in your hardhat config
    //
    // For this to work correctly, your network config must define an eid property
    // set to `EndpointId` as defined in @layerzerolabs/lz-definitions
    //
    // For example:
    //
    // networks: {
    //   fuji: {
    //     ...
    //     eid: EndpointId.AVALANCHE_V2_TESTNET
    //   }
    // }
    let endpointV2
    try {
        const endpointV2Deployment = await hre.deployments.get('EndpointV2')
        endpointV2 = endpointV2Deployment.address
    } catch (error) {
        if (network.name === "base-sepolia") {
            endpointV2 = EndpointV2_BASE_SEPOLIA
        } else {
            throw error
        }
    }

    // If the oftAdapter configuration is defined on a network that is deploying an OFT,
    // the deployment will log a warning and skip the deployment
    if (hre.network.config.oftAdapter != null) {
        console.warn(`oftAdapter configuration found on OFT deployment, skipping OFT deployment`)
        return
    }

    const { address } = await deploy(contractName, {
        from: deployer,
        args: [
            TOKENS_PER_NFT,
            endpointV2, // LayerZero's EndpointV2 address
            deployer, // owner
        ],
        log: true,
        skipIfAlreadyDeployed: false,
    })

    console.log(`Deployed contract: ${contractName}, network: ${hre.network.name}, address: ${address}`)

    // setting the base uri

    const bonsai = getContract(deployerSigner, 'BonsaiOFT', address, 'artifacts/contracts')
    const tx = await bonsai.setBaseURI(URI)
    console.log(`setting base uri: ${tx.hash}`)
    await tx.wait();
}

deploy.tags = [contractName]

export default deploy
