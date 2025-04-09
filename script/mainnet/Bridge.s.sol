// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SendParam } from "@layerzerolabs/oft-evm/contracts/interfaces/IOFT.sol";
import { MessagingFee } from "@layerzerolabs/oft-evm/contracts/OFTCore.sol";
import {OptionsBuilder} from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

import {BonsaiOFT} from "../../contracts/BonsaiOFT.sol";
import {BonsaiOFTAdapter} from "../../contracts/BonsaiOFTAdapter.sol";

// @dev this script allows the deployer to bridge bonsai tokens from polygon to zksync/base/lens
contract LzSendPolygon is Script {
    using OptionsBuilder for bytes;

    address BONSAI_OFT_ADAPTER = 0x303b63e785B656ca56ea5A5C1634Ab20C98895e1;
    address BONSAI_TOKEN = 0x3d2bD0e15829AA5C362a4144FdF4A1112fa29B5c;
    uint32 ZKSYNC_V2_MAINNET = 30165;
    uint32 BASE_V2_MAINNET = 30184;
    uint32 LENS_V2_MAINNET = 30373;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);
        address owner = vm.addr(deployerPrivateKey);

        // sending 1mil
        uint256 rewards = 500_000 ether;
        // for (uint256 i = 0; i < 2; i++) {
            _send(rewards, owner);
            _send(rewards, owner);
        // }

        vm.stopBroadcast();
    }

    function _send(uint256 tokensToSend, address to) internal {
        IERC20 bonsai = IERC20(BONSAI_TOKEN);
        BonsaiOFTAdapter adapter = BonsaiOFTAdapter(BONSAI_OFT_ADAPTER);

        // approve for the adapter
        bonsai.approve(address(adapter), tokensToSend);

        // prep the send
        SendParam memory sendParam = SendParam(
            LENS_V2_MAINNET,
            _addressToBytes32(to),
            tokensToSend,
            tokensToSend,
            OptionsBuilder.newOptions().addExecutorLzReceiveOption(500_000, 0),
            "",
            ""
        );

        // quote for native fee; not paying in ZRO
        MessagingFee memory fee = adapter.quoteSend(sendParam, false);

        // send
        adapter.send{ value: fee.nativeFee }(sendParam, fee, payable(address(this)));
    }

    function _addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}

// @dev this script allows the deployer to bridge bonsai tokens from base to zksync
contract LzSendBase is Script {
    using OptionsBuilder for bytes;

    address BONSAI_TOKEN_BASE = 0x474f4cb764df9da079D94052fED39625c147C12C;
    address BONSAI_OFT_ADAPTER_BASE = 0x474f4cb764df9da079D94052fED39625c147C12C;
    uint32 ZKSYNC_V2_MAINNET = 30165;
    uint32 BASE_V2_MAINNET = 30184;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);
        address owner = vm.addr(deployerPrivateKey);

        // sending 14.5mil
        uint256 rewards = 500_000 ether;
        _send(rewards, owner);
        for (uint256 i = 0; i < 14; i++) {
            _send(rewards, owner);
            _send(rewards, owner);
        }

        vm.stopBroadcast();
    }

    function _send(uint256 tokensToSend, address to) internal {
        BonsaiOFTAdapter adapter = BonsaiOFTAdapter(BONSAI_OFT_ADAPTER_BASE);

        // prep the send
        SendParam memory sendParam = SendParam(
            ZKSYNC_V2_MAINNET,
            _addressToBytes32(to),
            tokensToSend,
            tokensToSend,
            OptionsBuilder.newOptions().addExecutorLzReceiveOption(500_000, 0),
            "",
            ""
        );

        // quote for native fee; not paying in ZRO
        MessagingFee memory fee = adapter.quoteSend(sendParam, false);

        // send
        adapter.send{ value: fee.nativeFee }(sendParam, fee, payable(address(this)));
    }

    function _addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}

// @dev this script allows the deployer to bridge bonsai tokens from zksync to base
contract LzSendZkSync is Script {
    using OptionsBuilder for bytes;

    address BONSAI_TOKEN_ZKSYNC = 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82;
    address BONSAI_OFT_ADAPTER_ZKSYNC = 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82;
    uint32 ZKSYNC_V2_MAINNET = 30165;
    uint32 BASE_V2_MAINNET = 30184;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);
        address owner = vm.addr(deployerPrivateKey);

        // sending 1mil
        uint256 rewards = 500_000 ether;
        // for (uint256 i = 0; i < 14; i++) {
            _send(rewards, owner);
            // _send(rewards, owner);
        // }

        vm.stopBroadcast();
    }

    function _send(uint256 tokensToSend, address to) internal {
        BonsaiOFTAdapter adapter = BonsaiOFTAdapter(BONSAI_OFT_ADAPTER_ZKSYNC);

        // prep the send
        SendParam memory sendParam = SendParam(
            BASE_V2_MAINNET,
            _addressToBytes32(to),
            tokensToSend,
            tokensToSend,
            OptionsBuilder.newOptions().addExecutorLzReceiveOption(500_000, 0),
            "",
            ""
        );

        // quote for native fee; not paying in ZRO
        MessagingFee memory fee = adapter.quoteSend(sendParam, false);

        // send
        adapter.send{ value: fee.nativeFee }(sendParam, fee, payable(address(this)));
    }

    function _addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}

// @dev this script allows the deployer to set the peer on the polygon adapter
contract SetPeer is Script {
    using OptionsBuilder for bytes;

    address BONSAI_OFT_ADAPTER = 0x303b63e785B656ca56ea5A5C1634Ab20C98895e1;
    address BONSAI_OFT_LENS = 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82;
    uint32 LENS_V2_MAINNET = 30373;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);

        BonsaiOFTAdapter adapter = BonsaiOFTAdapter(BONSAI_OFT_ADAPTER);

        adapter.setPeer(LENS_V2_MAINNET, _addressToBytes32(address(BONSAI_OFT_LENS)));

        vm.stopBroadcast();
    }

    function _addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}