// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { BonsaiOFT } from "../BonsaiOFT.sol";

// @dev WARNING: This is for testing purposes only
contract MyOFTMock is BonsaiOFT {
    uint96 tokensPerNft = 100_000;

    constructor(
        address _lzEndpoint,
        address _delegate
    ) BonsaiOFT(tokensPerNft, _lzEndpoint, _delegate) {}

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
