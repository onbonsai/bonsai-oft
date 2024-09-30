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

// @dev this script is used to the deploy BonsaiOFT.sol to zksync sepolia testnet
contract SetPeer is Script {
    address BONSAI_OFT = 0x3d2bD0e15829AA5C362a4144FdF4A1112fa29B5c;
    address BONSAI_OFT_ADAPTER = 0x9918889E93e8c4357a2D4bCE0965dcC493FFFDA8;
    address ZORA_CREATOR = 0x482107B5966178b595758069E80D7DD7F1652622;
    uint32 remoteEid = 40267; // amoy

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_HEX");
        vm.startBroadcast(deployerPrivateKey);

        BonsaiOFT(payable(BONSAI_OFT)).setPeer(remoteEid, _addressToBytes32(address(BONSAI_OFT_ADAPTER)));

        vm.stopBroadcast();
    }

    function _addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}