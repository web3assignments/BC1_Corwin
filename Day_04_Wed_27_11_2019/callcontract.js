const Web3 = require('web3');
const web3 = new Web3('https://ropsten.infura.io');
const getBankBalanceABI = [{
    "constant": true,
    "inputs": [],
    "name": "getBankBalance",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "ret",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}];

const CasinoV2Address = "0x8b173E32DbE8DA7746ef1a61FDb214b5Fa6F7DE4";
const ContractCasinoV2 = new web3.eth.Contract(getBankBalanceABI, CasinoV2Address);
async function f() { 
    var result = await ContractCasinoV2.methods.getBankBalance().call();
    console.log(result);
}
f();
