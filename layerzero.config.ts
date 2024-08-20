import { EndpointId } from '@layerzerolabs/lz-definitions'

import type { OAppOmniGraphHardhat, OmniPointHardhat } from '@layerzerolabs/toolbox-hardhat'

/**
 *  WARNING: ONLY 1 OFTAdapter should exist for a given global mesh.
 *  The token address for the adapter should be defined in hardhat.config. This will be used in deployment.
 *
 *  for example:
 *
 *    sepolia: {
 *         eid: EndpointId.SEPOLIA_V2_TESTNET,
 *         url: process.env.RPC_URL_SEPOLIA || 'https://rpc.sepolia.org/',
 *         accounts,
 *         oft-adapter: {
 *             tokenAddress: '0x0', // Set the token address for the OFT adapter
 *         },
 *     },
 */
const baseContract: OmniPointHardhat = {
    eid: EndpointId.BASE_V2_TESTNET,
    contractName: 'BonsaiOFT',
}

const zksyncContract: OmniPointHardhat = {
    eid: EndpointId.ZKSYNC_V2_TESTNET,
    contractName: 'BonsaiOFT',
}

const amoyContract: OmniPointHardhat = {
    eid: EndpointId.AMOY_V2_TESTNET,
    contractName: 'BonsaiOFTAdapter',
}

const config: OAppOmniGraphHardhat = {
    contracts: [
        {
            contract: baseContract,
        },
        {
            contract: zksyncContract,
        },
        {
            contract: amoyContract,
        },
    ],
    connections: [
        {
            from: baseContract,
            to: zksyncContract,
        },
        {
            from: baseContract,
            to: amoyContract,
        },
        {
            from: zksyncContract,
            to: baseContract,
        },
        {
            from: zksyncContract,
            to: amoyContract,
        },
        {
            from: amoyContract,
            to: zksyncContract,
        },
        {
            from: amoyContract,
            to: baseContract,
        },
    ],
}

export default config
