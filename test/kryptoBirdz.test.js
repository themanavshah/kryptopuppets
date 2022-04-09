const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');

const web3 = new Web3(ganache.provider());

const compiledKryptoPupz = require('../ethereum/build/KryptoPuppet.json');

let accounts;
let kryptoPupz;

beforeEach(async () => {

    accounts = await web3.eth.getAccounts();

    kryptoPupz = await new web3.eth.Contract(compiledKryptoPupz.abi)
        .deploy({ data: compiledKryptoPupz.evm.bytecode.object})
        .send({from: accounts[0], gas: '2000000'});

});

describe('deploys Kryptopupz NFT', () => {
    it('deploys a the NFT project', () => {
        //console.log(kryptoPupz.options.address);
        assert.ok(kryptoPupz.options.address);
    });

    it('has the correct name', async () => {
        const inName = await kryptoPupz.methods.name().call();
        assert.equal(inName, 'KryptoPuppet');
    });

    it('has the correct symbol', async () => {
        const inSymbol = await kryptoPupz.methods.symbol().call();
        assert.equal(inSymbol, 'KPUPZ');
    });
});

describe('minting works correctly', () => {

    it('minting works', async () => {
        await kryptoPupz.methods.mint('Blue puppet').send({
            from: accounts[0],
            gas: '1000000'
        });
        const puppLis = await kryptoPupz.methods.getKPUPList().call();
        assert.equal('Blue puppet', puppLis[0]);
        assert.equal(puppLis.length, 1);
    });

    it('should fail when re-minint the same NFT', async () => {
        await kryptoPupz.methods.mint('Blue puppet').send({
            from: accounts[0],
            gas: '1000000'
        });
        try {
            await kryptoPupz.methods.mint('Blue puppet').send({
                from: accounts[0],
                gas: '1000000'
            });
            console.log('Something is wrong!');
            assert('0', '1');
        } catch (err) {
            assert(err);
        }
    });

});

describe('seeing of balance of and owner of token is right!', () => {

    it('should increment the balance of owner by 1.', async () => {
        await kryptoPupz.methods.mint('Blue puppet').send({
            from: accounts[0],
            gas: '1000000'
        });
        const balance = await kryptoPupz.methods.balanceOf(accounts[0]).call();
        assert.equal(balance, 1);
    });

    it('checking owner of the previously minted NFT.', async () => {
        await kryptoPupz.methods.mint('Blue puppet').send({
            from: accounts[0],
            gas: '1000000'
        });
        const ownerAd = await kryptoPupz.methods.ownerOf(0).call();
        assert.equal(ownerAd, accounts[0]);
    });

});

describe('fetching and checking enumeration of NFT project.', () => {

    it('total supply should match the number of NFTs.', async () => {
        await kryptoPupz.methods.mint('Blue puppet').send({
            from: accounts[0],
            gas: '1000000'
        });
        const totalToken1 = await kryptoPupz.methods.totalSupply().call();
        assert.equal(totalToken1, 1);

        await kryptoPupz.methods.mint('yellow vamp pup').send({
            from: accounts[0],
            gas: '1000000'
        });

        const totalToken2 = await kryptoPupz.methods.totalSupply().call();
        assert.equal(totalToken2, 2);
    });

});