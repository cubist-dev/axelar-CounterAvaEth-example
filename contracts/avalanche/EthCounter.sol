// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

contract EthCounter is AxelarExecutable {
    IAxelarGasService public immutable gasReceiver;

    // The destination on Ethereum
    string ethAddress;

    constructor(
        address gateway_,
        address gasReceiver_,
        string memory ethAddress_
    ) AxelarExecutable(gateway_) {
        gasReceiver = IAxelarGasService(gasReceiver_);
        ethAddress = ethAddress_;
    }

    // function id 0
    function store(uint256 num) external payable {
        bytes memory args = abi.encode(num);
        bytes memory payload = abi.encode(0, args);
        gasReceiver.payNativeGasForContractCall{value: msg.value}(
            address(this),
            "ethereum",
            ethAddress,
            payload,
            msg.sender
        );
        gateway.callContract("ethereum", ethAddress, payload);
    }

    // function id 1
    function inc() external payable {
        bytes memory args = "";
        bytes memory payload = abi.encode(1, args);
        gasReceiver.payNativeGasForContractCall{value: msg.value}(
            address(this),
            "ethereum",
            ethAddress,
            payload,
            msg.sender
        );
        gateway.callContract("ethereum", ethAddress, payload);
    }

    function _execute(
        string calldata,
        string calldata,
        bytes calldata
    ) internal override {}
}
