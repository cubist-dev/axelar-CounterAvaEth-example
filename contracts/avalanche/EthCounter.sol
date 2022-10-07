// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

contract EthCounter is AxelarExecutable {
    IAxelarGasService public immutable gasReceiver;

    // The destination on Ethereum
    string ethCounterInterfaceAddress;

    constructor(
        address gateway_,
        address gasReceiver_,
        string memory ethCounterInterfaceAddress_
    ) AxelarExecutable(gateway_) {
        gasReceiver = IAxelarGasService(gasReceiver_);
        ethCounterInterfaceAddress = ethCounterInterfaceAddress_;
    }

    function store(uint256 num) external payable {
        bytes memory payload = abi.encodeWithSignature("store(uint256)", num);
        gasReceiver.payNativeGasForContractCall{value: msg.value}(
            address(this),
            "ethereum",
            ethCounterInterfaceAddress,
            payload,
            msg.sender
        );
        gateway.callContract("ethereum", ethCounterInterfaceAddress, payload);
    }

    function inc() external payable {
        bytes memory payload = abi.encodeWithSignature("inc()");
        gasReceiver.payNativeGasForContractCall{value: msg.value}(
            address(this),
            "ethereum",
            ethCounterInterfaceAddress,
            payload,
            msg.sender
        );
        gateway.callContract("ethereum", ethCounterInterfaceAddress, payload);
    }

    function _execute(
        string calldata,
        string calldata,
        bytes calldata
    ) internal override {}
}
