const Web3 = require('web3');

// set up web3 provider
const provider = new Web3.providers.HttpProvider('http://localhost:7545'); // replace with your Ganache provider URL
const web3 = new Web3(provider);

// set up contract
const contractAddress = '0x58bcbFA9427475Ae6C0ED6d224A7798aD0B32223'; // replace with your contract address
const abi = [
                {
                    "inputs": [],
                    "stateMutability": "payable",
                    "type": "constructor",
                    "payable": true
                },
                {
                    "inputs": [],
                    "name": "betFeeETH",
                    "outputs": [
                                    {
                                        "internalType": "uint256",
                                        "name": "",
                                        "type": "uint256"
                                    }
                                ],
                    "stateMutability": "view",
                    "type": "function",
                    "constant": true
                },
                {
                    "inputs":   [
                                    {
                                        "internalType": "address",
                                        "name": "_newOwner",
                                        "type": "address"
                                    }
                                ],
                    "name": "changeOwner",
                    "outputs": [],
                    "stateMutability": "nonpayable",
                    "type": "function"
                },
                {
                    "inputs": [],
                    "name": "deposit",
                    "outputs": [],
                    "stateMutability": "payable",
                    "type": "function",
                    "payable": true
                },
                {
                    "inputs": [],
                    "name": "getBalance",
                    "outputs": [
                                    {
                                        "internalType": "uint256",
                                        "name": "",
                                        "type": "uint256"
                                    }
                                ],
                    "stateMutability": "view",
                    "type": "function",
                    "constant": true
                },
                {
                    "inputs": [],
                    "name": "getOwner",
                    "outputs": [
                                    {
                                        "internalType": "address",
                                        "name": "",
                                        "type": "address"
                                    }
                                ],
                    "stateMutability": "view",
                    "type": "function",
                    "constant": true
                },
                {
                    "inputs": [],
                    "name": "maxBetETH",
                    "outputs": [
                                    {
                                        "internalType": "uint256",
                                        "name": "",
                                        "type": "uint256"
                                    }
                                ],
                    "stateMutability": "view",
                    "type": "function",
                    "constant": true
                },
                {
                    "inputs":  [
                                    {
                                        "internalType": "uint256",
                                        "name": "_newFee",
                                        "type": "uint256"
                                    }
                                ],
                    "name": "setBetFee",
                    "outputs": [],
                    "stateMutability": "nonpayable",
                    "type": "function"
                },
                {
                    "inputs":  [
                                    {
                                        "internalType": "uint256",
                                        "name": "_newAmount",
                                        "type": "uint256"
                                    }
                                ],
                    "name": "setMaxBet",
                    "outputs": [],
                    "stateMutability": "nonpayable",
                    "type": "function"
                },
                {
                    "inputs": [],
                    "name": "toggleContractActive",
                    "outputs": [],
                    "stateMutability": "nonpayable",
                    "type": "function"
                },
                {
                    "inputs": [],
                    "name": "withdraw",
                    "outputs": [],
                    "stateMutability": "nonpayable",
                    "type": "function"
                },
                {
                    "inputs":  [
                                    {
                                        "internalType": "uint8",
                                        "name": "_userChoice",
                                        "type": "uint8"
                                    }
                                ],
                    "name": "bet",
                    "outputs": [],
                    "stateMutability": "payable",
                    "type": "function",
                    "payable": true
                }
            ]; // replace with your contract ABI
const coinFlipContract = new web3.eth.Contract(abi, contractAddress);

// set up accounts
const accounts = await web3.eth.getAccounts();
const player = accounts[0]; // choose the player account here

// get min and max bets
const minBet = await coinFlipContract.methods.getMinBet().call();
const maxBet = await coinFlipContract.methods.getMaxBet().call();

// place a bet and call flipCoin function
const betAmount = 100; // replace with your desired bet amount
const functionData = coinFlipContract.methods.flipCoin(betAmount).encodeABI();
const gasPrice = await web3.eth.getGasPrice();
const gasEstimate = await coinFlipContract.methods.flipCoin(betAmount).estimateGas({from: player, value: betAmount, data: functionData});

// sign transaction with player account private key
const privateKey = '13ce4fcf0f56a23efe64e30a415f43d17738840bf4484da63056b9b2fa3825f3'; // replace with your player account private key
const signedTx = await web3.eth.accounts.signTransaction({
    to: contractAddress,
    value: betAmount,
    data: functionData,
    gas: gasEstimate,
    gasPrice: gasPrice
}, privateKey);

// send transaction
const txReceipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
console.log('Transaction receipt:', txReceipt);
