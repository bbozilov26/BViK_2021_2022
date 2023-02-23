const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545")); // Update with your Ganache URL

const abi = [
                {
                    "inputs":[],
                    "stateMutability":"payable",
                    "type":"constructor"
                },
                {
                    "inputs":[{
                                "internalType":"uint256",
                                "name":"num",
                                "type":"uint256"}],
                    "name":"guess",
                    "outputs":[],
                    "stateMutability":"nonpayable",
                    "type":"function"
                },
                {
                    "inputs":[],
                    "name":"withdraw",
                    "outputs":[],
                    "stateMutability":"nonpayable",
                    "type":"function"
                },
                {
                    "inputs":[],
                    "name":"deposit",
                    "outputs":[],
                    "stateMutability":"payable",
                    "type":"function"
                }
            ];
const contractAddress = "0x665bb580F293B0224E31C3595eEb8EA4697165DD"; // Update with your deployed contract address
const guessTheNumber = new web3.eth.Contract(abi, contractAddress);

async function playGuessTheNumber(accountIndex) {
    const accounts = await web3.eth.getAccounts();
    const account = accounts[accountIndex];

    // Get the current contract balance and player address
    const contractBalance = await guessTheNumber.methods.contractBalance().call();
    const player = await guessTheNumber.methods.player().call();

    // Check if the selected account is the player
    if (account !== player) {
        console.log("Only the player can make a guess.");
        return;
    }

    // Get user input for the guess
    const readline = require("readline").createInterface({
        input: process.stdin,
        output: process.stdout
    });

    readline.question("Enter your guess (between 1 and 10): ", async (guess) => {
        if (isNaN(guess)) {
            console.log("Invalid input. Guess must be a number.");
            readline.close();
            return;
        }

        if (guess < 1 || guess > 10) {
            console.log("Guess must be within range of 1 to 10.");
            readline.close();
            return;
        }

        // Make the guess transaction
        try {
            const gasPrice = await web3.eth.getGasPrice();
            const gasLimit = await guessTheNumber.methods.guess(guess).estimateGas();
            const tx = {
                from: account,
                to: contractAddress,
                gasPrice: gasPrice,
                gas: gasLimit
            };
            const receipt = await guessTheNumber.methods.guess(guess).send(tx);
            console.log(receipt);
        } catch (error) {
            console.log(error.message);
        }

        readline.close();
    });
}

playGuessTheNumber(0); // Replace with the index of the desired account in Ganache
