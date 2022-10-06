'use strict';

require("dotenv").config();
const { utils: { deployContract, setJSON } } = require('@axelar-network/axelar-local-dev');
const { Wallet, getDefaultProvider } = require('ethers');

async function deploy(wallet, chain, contract_name, params) {
    console.log(`Deploying ${chain.name} contract ${contract_name}`);
    const provider = getDefaultProvider(chain.rpc);
    const contract = require(`../artifacts/contracts/${chain.name}/${contract_name}.sol/${contract_name}.json`);
    const res = await deployContract(wallet.connect(provider), contract, params);
    chain[contract_name] = res.address;
    console.log(`Deployed at ${res.address}`);
    return res.address
}

async function deployContracts(wallet, chains) {
    const ava = chains.get("avalanche");
    const eth = chains.get("ethereum");
    const eth_address = await deploy(wallet, eth, 'EthCounter', []);
    const eth_intf_address = await deploy(wallet, eth, 'EthCounterInterface', [eth.gateway, eth.gasReceiver, eth_address]);
    const ava_eth_intf_address = await deploy(wallet, ava, 'EthCounter', [ava.gateway, ava.gasReceiver, eth_intf_address]);
    await deploy(wallet, chains.get("avalanche"), 'AvaCounter', [ava_eth_intf_address]);
    setJSON(Array.from(chains.values()), `./info/local.json`);
}

if (require.main === module) {
    const example = null;
    const chain_infos = require(`../info/local.json`);
    const chains = new Map(chain_infos.map(i => [i.name, i]));
    const private_key = process.env.EVM_PRIVATE_KEY;
    const wallet = new Wallet(private_key);
    deployContracts(wallet, chains);
}
