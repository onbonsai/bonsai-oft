// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BonsaiOFT} from "../../contracts/BonsaiOFT.sol";

// @dev this script allows use to read from BonsaiOFT on zksync/base
contract Read is Script {
    address BONSAI_TOKEN_ZKSYNCSEP = 0xB0588f9A9cADe7CD5f194a5fe77AcD6A58250f82;
    address BONSA_MIRROR_ZKSYNCSEP = 0x40df0F8C263885093DCCEb4698DE3580FC0C9D49;

    address BONSAI_TOKEN_BASESEP = 0x3d2bD0e15829AA5C362a4144FdF4A1112fa29B5c;
    address BONSAI_MIRROR_BASESEP = 0xE9d2FA815B95A9d087862a09079549F351DaB9bd;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);

        address owner = vm.addr(deployerPrivateKey);
        uint256 balance = BonsaiOFT(payable(BONSAI_MIRROR_BASESEP)).balanceOf(owner);
        console.log("mirror.balance", balance);

        vm.stopBroadcast();
    }
}
