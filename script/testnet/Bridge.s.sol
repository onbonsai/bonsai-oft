// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SendParam } from "@layerzerolabs/oft-evm/contracts/interfaces/IOFT.sol";
import { MessagingFee } from "@layerzerolabs/oft-evm/contracts/OFTCore.sol";

import {BonsaiOFT} from "../../contracts/BonsaiOFT.sol";
import {BonsaiOFTAdapter} from "../../contracts/BonsaiOFTAdapter.sol";

// @dev this script allows the deployer to bridge bonsai tokens from polygon to zksync/base
contract LzSendPolygon is Script {
    address BONSAI_OFT_ADAPTER = 0x9918889E93e8c4357a2D4bCE0965dcC493FFFDA8;
    address BONSAI_TOKEN = 0x3d2bD0e15829AA5C362a4144FdF4A1112fa29B5c;
    uint32 ZKSYNCSEP_V2_TESTNET = 40305;
    uint32 BASESEP_V2_TESTNET = 40245;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);
        address owner = vm.addr(deployerPrivateKey);

        // _send(50 ether, owner);
        // _send(100 ether, owner);
        // _send(1_000 ether, owner);
        // _send(10_000 ether, owner);
        _send(100_000 ether, owner);
        // _send(200_000 ether, owner);

        vm.stopBroadcast();
    }

    function _send(uint256 tokensToSend, address to) internal {
        IERC20 bonsai = IERC20(BONSAI_TOKEN);
        BonsaiOFTAdapter adapter = BonsaiOFTAdapter(BONSAI_OFT_ADAPTER);

        // approve for the adapter
        bonsai.approve(address(adapter), tokensToSend);

        // prep the send
        SendParam memory sendParam = SendParam(
            ZKSYNCSEP_V2_TESTNET,
            _addressToBytes32(to),
            tokensToSend,
            tokensToSend,
            "", // extraOptions
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
