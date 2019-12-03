const Web3 = require('web3');
const web3 = new Web3('https://ropsten.infura.io');
const TestSetABI = [{
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

const TestAddress = "0x8b173E32DbE8DA7746ef1a61FDb214b5Fa6F7DE4";
const ContractTest = new web3.eth.Contract(TestSetABI, TestAddress);
async function f() { 
    var result = await ContractTest.methods.getBankBalance().call();
    console.log(result);
}
f();
