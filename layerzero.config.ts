import { EndpointId } from '@layerzerolabs/lz-definitions'
import { ExecutorOptionType } from '@layerzerolabs/lz-v2-utilities'
import { TwoWayConfig, generateConnectionsConfig } from '@layerzerolabs/metadata-tools'

import type { OAppOmniGraphHardhat, OmniPointHardhat, OAppEnforcedOption } from '@layerzerolabs/toolbox-hardhat'

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
    eid: EndpointId.BASE_V2_MAINNET,
    contractName: 'BonsaiOFT',
}

const zksyncContract: OmniPointHardhat = {
    eid: EndpointId.ZKSYNC_V2_MAINNET,
    contractName: 'BonsaiOFT',
}

const polygonContract: OmniPointHardhat = {
    eid: EndpointId.POLYGON_V2_MAINNET,
    contractName: 'BonsaiOFTAdapter',
}

const lensContract: OmniPointHardhat = {
    eid: EndpointId.LENS_V2_MAINNET,
    contractName: 'BonsaiOFT',
}

// requirement for listing on stargate
const enforcedOptions: OAppEnforcedOption[] = [
    {
        msgType: 1, // depending on OAppOptionType3
        optionType: ExecutorOptionType.LZ_RECEIVE,
        gas: 110_000, // gas limit in wei for EndpointV2.lzReceive
        value: 0, // msg.value in wei for EndpointV2.lzReceive
    },
]

const pathways: TwoWayConfig[] = [
    [
        baseContract,
        zksyncContract,
        [['LayerZero Labs'], []], // [ requiredDVN[], [ optionalDVN[], threshold ] ]
        [1, 1], // [A to B confirmations, B to A confirmations]
        [enforcedOptions, enforcedOptions], // Chain B enforcedOptions, Chain A enforcedOptions
    ],
    [
        baseContract,
        polygonContract,
        [['LayerZero Labs'], []], // [ requiredDVN[], [ optionalDVN[], threshold ] ]
        [1, 1],
        [enforcedOptions, enforcedOptions],
    ],
    [
        baseContract,
        lensContract,
        [['LayerZero Labs'], []],
        [1, 1],
        [enforcedOptions, enforcedOptions],
    ],
    [
        zksyncContract,
        polygonContract,
        [['LayerZero Labs'], []],
        [1, 1],
        [enforcedOptions, enforcedOptions],
    ],
    [
        zksyncContract,
        lensContract,
        [['LayerZero Labs'], []],
        [1, 1],
        [enforcedOptions, enforcedOptions],
    ],
    [
        polygonContract,
        lensContract,
        [['LayerZero Labs'], []],
        [1, 1],
        [enforcedOptions, enforcedOptions],
    ],
]

export default async function () {
    // Generate the connections config based on the pathways
    const connections = await generateConnectionsConfig(pathways)
    return {
        contracts: [
            {
                contract: baseContract,
            },
            {
                contract: zksyncContract,
            },
            {
                contract: polygonContract,
            },
            {
                contract: lensContract,
            },
        ],
        connections,
    }
}
