const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');

const compiledFactory = require('./build/KryptoPuppet.json');

const provider = new HDWalletProvider(
    'okay mother hurry quick laugh arena barrel scare prepare faith because blind',
    'https://rinkeby.infura.io/v3/5c98c4ca077043c1b9a0c80794958eba'
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
