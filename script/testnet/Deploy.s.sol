// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BonsaiOFT} from "../../contracts/BonsaiOFT.sol";

// @dev this script is used to the deploy BonsaiOFT.sol to zksync sepolia testnet
contract DeployBonsaiOFT is Script {
    address LZ_ENDPOINT_V2 = 0xe2Ef622A13e71D9Dd2BBd12cd4b27e1516FA8a09;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);

        address owner = vm.addr(deployerPrivateKey);
        uint96 tokensPerNft = 100_000;

        // WITH ART
        string memory baseURI_ = "ipfs://bafybeiba7hsqirohcgqibxokpml7eoh65z7fagah7ed7ggejud265ro2ky/";

        BonsaiOFT bonsai = new BonsaiOFT(tokensPerNft, LZ_ENDPOINT_V2, owner);
        bonsai.setBaseURI(baseURI_);

        vm.stopBroadcast();
    }
}
