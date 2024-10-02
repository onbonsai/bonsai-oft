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

// requirement for listing on stargate
const enforcedOptions: any[] = [
    {
        msgType: 1, // depending on OAppOptionType3
        optionType: ExecutorOptionType.LZ_RECEIVE,
        gas: 110_000, // gas limit in wei for EndpointV2.lzReceive
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
            contract: polygonContract,
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
            to: polygonContract,
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
            to: polygonContract,
            config: {
                enforcedOptions,
                sendConfig: {
                    executorConfig: {
                        maxMessageSize: 10000,
                        executor: "0x664e390e672A811c12091db8426cBb7d68D5D8A6",
                    },
                    ulnConfig: {
                        confirmations: BigInt(42),
                        requiredDVNs: ["0x620a9df73d2f1015ea75aea1067227f9013f5c51"], // LayerZero Labs
                        optionalDVNs: [
                            "0x62aa89bad332788021f6f4f4fb196d5fe59c27a6", // Stargate
                        ],
                        optionalDVNThreshold: 1,
                    }
                },
                receiveConfig: {
                    ulnConfig: {
                        confirmations: BigInt(42),
                        requiredDVNs: ["0x620a9df73d2f1015ea75aea1067227f9013f5c51"], // LayerZero Labs
                        optionalDVNs: [
                            "0x62aa89bad332788021f6f4f4fb196d5fe59c27a6", // Stargate
                        ],
                        optionalDVNThreshold: 1,
                    }
                },
            }
        },
        {
            from: polygonContract,
            to: zksyncContract,
            config: {
                enforcedOptions,
                sendConfig: {
                    executorConfig: {
                        maxMessageSize: 10000,
                        executor: "0xCd3F213AD101472e1713C72B1697E727C803885b",
                    },
                    ulnConfig: {
                        confirmations: BigInt(42),
                        requiredDVNs: ["0x23de2fe932d9043291f870324b74f820e11dc81a"], // LayerZero Labs
                        optionalDVNs: [
                            "0xc79f0b1bcb7cdae9f9ba547dcfc57cbfcd2993a5", // Stargate
                        ],
                        optionalDVNThreshold: 1,
                    }
                },
                receiveConfig: {
                    ulnConfig: {
                        confirmations: BigInt(42),
                        requiredDVNs: ["0x23de2fe932d9043291f870324b74f820e11dc81a"], // LayerZero Labs
                        optionalDVNs: [
                            "0xc79f0b1bcb7cdae9f9ba547dcfc57cbfcd2993a5", // Stargate
                        ],
                        optionalDVNThreshold: 1,
                    }
                },
            }
        },
        {
            from: polygonContract,
            to: baseContract,
            config: {
                enforcedOptions
            }
        },
    ],
}

export default config
