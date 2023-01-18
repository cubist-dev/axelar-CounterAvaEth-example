# Axelar Example: A Simple Counter

## Overview

This repository is an example of using Axelar to do cross-chain calls using
interface contracts similar to the ones that Cubist will be generating. The
example is based on other [Axelar
examples](https://github.com/axelarnetwork/axelar-local-gmp-examples).

In this simple example, there are two functions (`inc()` and `store(uint256)`)
in an Ethereum contract (`EthCounter`) that we call from Avalanche through the
Axelar infrastructure. The contracts that a user would write are
[`EthCounter.sol`](contracts/ethereum/EthCounter.sol) (deployed on Ethereum)
and [`AvaCounter.sol`](contracts/avalanche/AvaCounter.sol) (deployed on
Avalanche).

On the Avalanche side there is an
[`EthCounter.sol`](contracts/avalanche/EthCounter.sol) contract that exposes
the cross-chain functions in an interface that corresponds to the contract on
the Ethereum side. The functions on this contract encode the function and
arguments for the cross-chain calls, use the Axelar API to pay for the
cross-chain calls, and then use the API to initiate the call. The cross-chain
function to call is encoded using `abi.encodeWithSignature()`.

On the Ethereum side there is an
[`EthCounterInterface.sol`](contracts/ethereum/EthCounterInterface.sol)
contract that acts as the receiving contract for calls from Axelar. To do so,
it overrides the `_execute()` function and [executes the call stored in the
payload on the original
contract](https://docs.soliditylang.org/en/v0.8.4/types.html#members-of-addresses).
It then matches the function id and invokes the corresponding function on the
original contract with the decoded arguments.


## Deployment

The deployment of the contracts in this repository has to happen in the
following order:

- `EthCounter` on Ethereum
- `EthCounterInterface` on Ethereum (requires the address of
  (`EthCounter`)
- `EthCounter` (the interface) on Avalanche (requires the address of
  `EthCounterInterface`)
- `AvaCounter` on Avalanche (requires the address of the `EthCounter`
  interface)

## Testing the example

Build contracts:

```bash
npm install
npx hardhat compile
```

Start servers (run command in a different terminal or background):

```bash
node scripts/runLocal.js
```

Deploy contracts:

```bash
node scripts/deploy.js
```

Test contracts/bridging:

```bash
node scripts/test.js
```
