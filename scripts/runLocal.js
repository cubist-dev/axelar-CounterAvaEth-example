'use strict';

require("dotenv").config();
const { createAndExport } = require('@axelar-network/axelar-local-dev');
const { Wallet } = require('ethers');

async function runLocal(toFund = []) {
    async function afterRelay(data) {
      console.log(data);
    }

    await createAndExport({
        chainOutputPath: "./info/local.json",
        accountsToFund: toFund,
        afterRelay: afterRelay,
        chains: ["ethereum", "avalanche"],
    });
}

if (require.main === module) {    
    const deployer_key = process.env.EVM_PRIVATE_KEY;
    const deployer_address = new Wallet(deployer_key).address;
    runLocal([deployer_address]);
}
