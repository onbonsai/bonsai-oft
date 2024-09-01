import { EndpointId } from '@layerzerolabs/lz-definitions'
import { ExecutorOptionType } from '@layerzerolabs/lz-v2-utilities'

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
    eid: EndpointId.BASESEP_V2_TESTNET,
    contractName: 'BonsaiOFT',
}

const zksyncContract: OmniPointHardhat = {
    eid: EndpointId.ZKSYNCSEP_V2_TESTNET,
    contractName: 'BonsaiOFT',
}

const amoyContract: OmniPointHardhat = {
    eid: EndpointId.AMOY_V2_TESTNET,
    contractName: 'BonsaiOFTAdapter',
}

// requirement for listing on stargate
const enforcedOptions: any[] = [
    {
        msgType: 1, // depending on OAppOptionType3
        optionType: ExecutorOptionType.LZ_RECEIVE,
        gas: 65_000, // gas limit in wei for EndpointV2.lzReceive
        value: 0, // msg.value in wei for EndpointV2.lzReceive
    }
]

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
            config: {
                enforcedOptions
            }
        },
        {
            from: baseContract,
            to: amoyContract,
            config: {
                enforcedOptions
            }
        },
        {
            from: zksyncContract,
            to: baseContract,
            config: {
                enforcedOptions
            }
        },
        {
            from: zksyncContract,
            to: amoyContract,
            config: {
                enforcedOptions
            }
        },
        {
            from: amoyContract,
            to: zksyncContract,
            config: {
                enforcedOptions
            }
        },
        {
            from: amoyContract,
            to: baseContract,
            config: {
                enforcedOptions
            }
        },
    ],
}

export default config
