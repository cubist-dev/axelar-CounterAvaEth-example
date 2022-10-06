// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "./EthCounter.sol";

contract AvaCounter {
    /// The EthCounter interface on Avalanche
    EthCounter ethCounter;
    uint256 number;

    /// @param ethCounterAddr The address of the EthCounter interface on Avalanche
    constructor(address ethCounterAddr) {
        ethCounter = EthCounter(ethCounterAddr);
        number = 0;
    }

    function store(uint256 num) external payable {
        ethCounter.store{value: msg.value}(num);
        number = num;
    }

    function inc() external payable {
        ethCounter.inc{value: msg.value}();
        number++;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}
