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

const contractABI = [
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "newSubscriber",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "subscriptionEnded",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAccess",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAmountOfSubscribers",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "_subID",
				"type": "address"
			}
		],
		"name": "getSubscriptionStatus",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "subscribe",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "subscribers",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "unsubscribe",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

const ContractAddress = "0x8B3ed23Bef30bE99f82B245eE37720883807565d";
const ContractSubscription = new web3.eth.Contract(contractABI, ContractAddress);
async function subscribe() { 
    web3 = new Web3(Web3.givenProvider);
    web3.extend({ // web3.eth.requestAccounts() isn't available (yet)
        methods: [{
            name: 'eth_requestAccounts',
            call: 'eth_requestAccounts',
            params: 0
        }]
    });
    var clientAddress = await web3.eth_requestAccounts().catch(x=>log(x.message));
    var result = await ContractSubscription.methods.subscribe().send({from: `${clientAddress}`});
    if (result) {
        log(`You are now a subscriber`);
    } else {
        log(`Subscription failed, please try again`);
    }
}

async function unsubscribe() { 
    web3 = new Web3(Web3.givenProvider);
    web3.extend({ // web3.eth.requestAccounts() isn't available (yet)
        methods: [{
            name: 'eth_requestAccounts',
            call: 'eth_requestAccounts',
            params: 0
        }]
    });
    var clientAddress = await web3.eth_requestAccounts().catch(x=>log(x.message));
    var result = await ContractSubscription.methods.unsubscribe().send({from: `${clientAddress}`});
    if (result) {
        log(`You are no longer a subscriber`);
    } else {
        log(`Unsubscribing failed, please try again`);
    }
}

async function getSubCount() {
    web3 = new Web3(Web3.givenProvider);
    var result = await ContractSubscription.methods.getAmountOfSubscribers().call();
    log(`There are currently ${result} amount of subscribers`);
}

async function access() {
    web3 = new Web3(Web3.givenProvider);
    web3.extend({ // web3.eth.requestAccounts() isn't available (yet)
        methods: [{
            name: 'eth_requestAccounts',
            call: 'eth_requestAccounts',
            params: 0
        }]
    });
    var clientAddress = await web3.eth_requestAccounts().catch(x=>log(x.message));
    var result = await ContractSubscription.methods.getAccess().send({from: `${clientAddress}`});
    if (result) {
        window.open("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
    } else {
        log(`You are not subscribed`);
    }
}

async function web3connection() {
    const web3Connect = new Web3Connect.Core({
        network: "mainnet", // optional
        providerOptions: {
            walletconnect: {
                package: WalletConnectProvider,
                    options: { infuraId: "0" } // dummy infura code!!
            }
        }
    });
    web3Connect.toggleModal();
    web3Connect.on("connect", OnConnect);
}

async function OnConnect(provider) {
    const web3 = new Web3(provider); // add provider to web3
    var acts=await web3.eth.getAccounts().catch(log);
    log(`Here are the accounts: ${JSON.stringify(acts)}`);
}

web3connection();
