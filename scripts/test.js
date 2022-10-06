'use strict';

require("dotenv").config();
const { testnetInfo } = require('@axelar-network/axelar-local-dev');
const { BigNumber, Contract, Wallet, getDefaultProvider, constants: { AddressZero } } = require('ethers');
const { keccak256, defaultAbiCoder } = require('ethers/lib/utils');

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve();
        }, ms);
    });
}

async function test(chains, wallet) {
    const ava = chains.get("avalanche");
    const ava_provider = getDefaultProvider(ava.rpc);
    const ava_wallet = wallet.connect(ava_provider);
    const ava_contract = require('../artifacts/contracts/avalanche/AvaCounter.sol/AvaCounter.json');
    const ava_counter = new Contract(ava.AvaCounter, ava_contract.abi, ava_wallet);

    const eth = chains.get("ethereum");
    const eth_provider = getDefaultProvider(eth.rpc);
    const eth_wallet = wallet.connect(eth_provider);
    const eth_contract = require('../artifacts/contracts/ethereum/EthCounter.sol/EthCounter.json');
    const eth_counter = new Contract(eth.EthCounter, eth_contract.abi, eth_wallet);

    console.log(`before ${await eth_counter.retrieve()}`);

    // Set the gas_limit to 3e5 (a safe overestimate) and get the gas price.
    const gas_limit = 3e5;
    const gas_price = 1;
    const new_val = BigNumber.from(5);

    console.log(`before: ${await eth_counter.retrieve()}`);

    await ava_counter.store(new_val, {
        value: BigInt(Math.floor(gas_limit * gas_price)),
    });
    await ava_counter.inc({
        value: BigInt(Math.floor(gas_limit * gas_price)),
    });

    while (!(await eth_counter.retrieve()).eq(new_val.add(1))) {
        console.log(`value not updated yet, waiting...`);
        await sleep(1000);
    }

    console.log(`after: ${await eth_counter.retrieve()}`);
}

if (require.main === module) {
    const private_key = process.env.EVM_PRIVATE_KEY;
    const wallet = new Wallet(private_key);
    const chain_infos = require(`../info/local.json`);
    const chains = new Map(chain_infos.map(i => [i.name, i]));
    test(chains, wallet);
}
