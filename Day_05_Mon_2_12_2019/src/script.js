function log(logstr) {   
    document.getElementById("log").innerHTML +=logstr+"\n";
}

web3 = new Web3(Web3.givenProvider);     
web3.extend({ // web3.eth.requestAccounts() isn't available (yet)
    methods: [{
        name: 'eth_requestAccounts',
        call: 'eth_requestAccounts',
        params: 0
    }]
}); 

async function getAccounts() { 
    web3 = new Web3(Web3.givenProvider); // provider from metamask         
    web3.extend({ // web3.eth.requestAccounts() isn't available (yet)
        methods: [{
            name: 'eth_requestAccounts',
            call: 'eth_requestAccounts',
            params: 0
        }]
    });
    log(`Version of web3.js: ${web3.version}`);            
    var result=await web3.eth_requestAccounts().catch(x=>log(x.message));
    log(`Value from eth_requestAccounts: ${JSON.stringify(result)}`);
    var acts=await web3.eth.getAccounts().catch(log);
    log(`Here are the accounts: ${JSON.stringify(acts)}`);
    
    ethereum.on('accountsChanged', newacts => { 
        acts=newacts;
        log(`We have new accounts: ${JSON.stringify(acts)}`);
    })
}

async function getChain() { 
    web3 = new Web3(Web3.givenProvider); // provider from metamask         
    web3.extend({ // web3.eth.requestAccounts() isn't available (yet)
        methods: [{
            name: 'eth_requestAccounts',
            call: 'eth_requestAccounts',
            params: 0
        }]
    });
    log(`Version of web3.js: ${web3.version}`);            
    var result=await web3.eth_requestAccounts().catch(x=>log(x.message));
    log(`Value from eth_requestAccounts: ${JSON.stringify(result)}`);
    var acts=await web3.eth.getAccounts().catch(log);
    log(`Here are the accounts: ${JSON.stringify(acts)}`);
    
    var chainId=await web3.eth.getChainId();
    log(`We are on chain: ${JSON.stringify(chainId)}`);            
    ethereum.on('chainChanged', newChain);
    ethereum.on('networkChanged',newChain); // still used in metamask mobile
    ethereum.on('chainIdChanged',newChain);      // temp workaround
    ethereum.autoRefreshOnNetworkChange = false; // temp workaround                    
    function newChain(newchainId) {
        chainId=newchainId;
        log(`We have a new chain: ${chainId}`);
    }
}
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
    web3 = new Web3(Web3.givenProvider);
    var result = await ContractCasinoV2.methods.getBankBalance().call();
    log(`There is ${result} Wei in the bank`);
}

getAccounts();
getChain();