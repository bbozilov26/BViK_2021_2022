// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Manager.sol";

contract GuessTheNumber is Manager {
    
    uint256 constant MAX_GUESS = 10;
    uint256 constant REWARD_PERCENT = 20;
    uint256 constant PENALTY_PERCENT = 25;
    
    uint256 public secretNumber;
    uint256 public contractBalance;
    address public player;
    uint256 public punishAmountTotal = 0;
    
    constructor() payable {
        require(msg.value > 0, "Insufficient reward amount.");
        player = msg.sender;
        secretNumber = uint256(keccak256(abi.encodePacked(block.timestamp, player))) % MAX_GUESS + 1;
        contractBalance = msg.value;
    }
    
    function guess(uint256 num) public {
        require(msg.sender == player, "Only the player can make a guess.");
        require(num >= 1 && num <= MAX_GUESS, "Guess must be within range of 1 to 10.");

         if (num == secretNumber) {
            // Player wins
            uint256 reward = contractBalance * REWARD_PERCENT / 100;
            contractBalance -= reward;
            
            // Transfer player's reward
            (bool success, ) = payable(player).call{value: reward}("");
            require(success, "Transfer failed. Deposit needed.");
        } else {
            // Player loses
            uint256 punishAmount = contractBalance * PENALTY_PERCENT / 100;
            punishAmountTotal += punishAmount;
            // Add punishAmount to contract's balance
            require(address(this).balance >= punishAmount, "Contract balance must be greater than or equal to punishAmount. Deposit needed.");
            
            contractBalance += punishAmount;
        }

        secretNumber = uint256(keccak256(abi.encodePacked(block.timestamp, player))) % MAX_GUESS + 1;
    }
    
    function withdraw() external isOwner stopInEmergency{
        (bool success, ) = payable(msg.sender).call{value: address(this).balance - punishAmountTotal}("");
        require(success, "Transfer failed. Deposit needed.");
        contractBalance = 0;
        punishAmountTotal = 0;
    }

    function deposit() external payable isOwner stopInEmergency {
        require(msg.value > 0, "Deposit must be greater than 0.");
        contractBalance += msg.value;
    }
}