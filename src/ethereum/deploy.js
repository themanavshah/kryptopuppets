const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');

const compiledFactory = require('./build/KryptoPuppet.json');

const SECRET_KEY_PHASE = "";
const INFURA_API_KEY = "";

const provider = new HDWalletProvider(
    SECRET_KEY_PHASE,
    `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`
);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0])

    const response = await new web3.eth.Contract(compiledFactory.abi)
                            .deploy({ data: compiledFactory.evm.bytecode.object})
                            .send({from: accounts[0], gas: '2000000'});

    console.log('Contract deployed at: ', response.options.address);
    provider.engine.stop();
};

deploy();
