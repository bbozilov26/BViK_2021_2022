// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GuessTheNumber {
    
    uint256 constant MAX_GUESS = 10;
    uint256 constant NUM_ATTEMPTS = 2;
    uint256 constant MAX_REWARD = 2 ether;
    // uint256 constant MIN_REWARD = 0.1 ether;
    uint256 constant INCENTIVE = 0.5 ether;
    uint256 constant PENALTY = 1 ether;
    uint256 public secretNumber;
    uint256 public numGuesses = 0;
    uint256 public reward;
    address public player;
    
    constructor() payable {
        require(msg.value >= 0, "Insufficient reward amount.");
        player = msg.sender;
        secretNumber = uint256(keccak256(abi.encodePacked(block.timestamp, player))) % MAX_GUESS + 1;
        reward = msg.value;
        // numGuesses = 0;
    }
    
    function guess(uint256 num) public {
        require(msg.sender == player, "Only the player can make a guess.");
        require(num >= 1 && num <= MAX_GUESS, "Guess must be within range of 1 to 10.");
        require(numGuesses < NUM_ATTEMPTS+1, "You have exceeded the maximum number of attempts.");
        numGuesses += 1;
        if (num == secretNumber) {
            // Player wins
            if (numGuesses == 1) {
                // Player wins in first attempt
                reward = MAX_REWARD;
            } else {
                // Calculate reward based on number of attempts
                reward = MAX_REWARD - (INCENTIVE * numGuesses);
            }
            // selfdestruct(payable(msg.sender));
            claimReward();
        } else if (numGuesses == NUM_ATTEMPTS) {
            // Player loses
            // reward = MIN_REWARD;
            reward -= PENALTY;
            // selfdestruct(payable(address(this)));
        } else {
            // Player continues guessing
            if (num > secretNumber) {
                // Guess is too high
                revert("Your guess is too high.");
            } else {
                // Guess is too low
                revert("Your guess is too low.");
            }
        }
    }
    
    function claimReward() private {
        require(msg.sender == player, "Only the player can claim the reward.");
        require(reward > 0, "There is no reward to claim.");
        uint256 amount = reward;
        reward = 0;
        numGuesses = 0;
        secretNumber = uint256(keccak256(abi.encodePacked(block.timestamp, player))) % MAX_GUESS + 1;
        payable(msg.sender).transfer(amount);
    }
    
    function withdraw() public {
        require(msg.sender == player, "Only the player can withdraw their funds.");
        selfdestruct(payable(msg.sender));
    }
}