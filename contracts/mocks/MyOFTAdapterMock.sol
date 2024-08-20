// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { BonsaiOFTAdapter } from "../BonsaiOFTAdapter.sol";

// @dev WARNING: This is for testing purposes only
contract MyOFTAdapterMock is BonsaiOFTAdapter {
    constructor(address _token, address _lzEndpoint, address _delegate) BonsaiOFTAdapter(_token, _lzEndpoint, _delegate) {}
}
