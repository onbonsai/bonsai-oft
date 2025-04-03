// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BonsaiOFT} from "../../contracts/BonsaiOFT.sol";

// @dev this script is used to the deploy BonsaiOFT.sol to lens mainnet
contract DeployBonsaiOFT is Script {
    address LZ_ENDPOINT_V2 = 0x5c6cfF4b7C49805F8295Ff73C204ac83f3bC4AE7;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);

        address owner = vm.addr(deployerPrivateKey);
        uint96 tokensPerNft = 100_000;

        // WITH ART
        string memory baseURI_ = "ipfs://bafybeieqxxnzxjxsjcoc77fo2iekytss2agsb34r3wpueqhw5bg32ymzku/";

        BonsaiOFT bonsai = new BonsaiOFT(tokensPerNft, LZ_ENDPOINT_V2, owner);
        bonsai.setBaseURI(baseURI_);

        vm.stopBroadcast();
    }
}