// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import "./EthCounter.sol";

contract EthCounterInterface is AxelarExecutable {
    IAxelarGasService public immutable gasReceiver;
    EthCounter ethCounter;

    constructor(
        address gateway_,
        address gasReceiver_,
        address ethCounterAddress
    ) AxelarExecutable(gateway_) {
        gasReceiver = IAxelarGasService(gasReceiver_);
        ethCounter = EthCounter(ethCounterAddress);
    }

    function _execute(
        string calldata,
        string calldata,
        bytes calldata payload_
    ) internal override {
        (bool success,) = address(ethCounter).call(payload_);
        require(success);
    }
}
