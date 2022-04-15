import web3 from './web3';
import KryptoPuppet from './build/KryptoPuppet.json';

const instance = new web3.eth.Contract(
    KryptoPuppet.abi,
    '0xf00F0B605f734ceb0E0CF3659E9f2Ceff4385fA8'
);

export default instance;