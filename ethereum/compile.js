const path = require('path');
const fs = require('fs-extra');
const solc = require('solc');

const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, 'contracts', 'KryptoPuppets.sol');
const source = fs.readFileSync(campaignPath, 'utf8');

// const output = solc.compile(source, 1);
// console.log(output);

const input = {
    language: 'Solidity',
    sources: {
      'KryptoPuppets.sol': {
        content: source,
      },
    },
    settings: {
      outputSelection: {
        '*': {
          '*': ['*'],
        },
      },
    },
  };


//console.log(solc.compile(JSON.stringify(input)));
console.log(JSON.parse(solc.compile(JSON.stringify(input))).contracts);
const output = JSON.parse(solc.compile(JSON.stringify(input))).contracts;

fs.ensureDirSync(buildPath);

for (let contract in output[Object.keys(output)[0]]) {
    fs.outputJSONSync(
        path.resolve(buildPath, contract + '.json'),
        output[Object.keys(output)[0]][contract]
    )
    //console.log(contract);
}