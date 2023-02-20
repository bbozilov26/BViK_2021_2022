// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Manager.sol";
import "./SafeMath.sol";

contract CoinFlip is Manager {

    using SafeMath for uint;
    // uint256 public betAmount;
    uint256 public contractBalance;
    // uint256 public minBet;
    // uint256 public maxBet;

    // Transfer funds to the contract upon deployment
    constructor() payable {
        // payable(address(this)).transfer(msg.value);
        contractBalance = msg.value;
    }

    // fallback() external payable {}

    function flipCoin() public payable{
        // require(msg.value == betAmount, "Please send the exact bet amount");
        require(msg.value >= this.getMinBet() && msg.value <= this.getMaxBet(), "Bet amount is not within the allowed range");
        require(contractBalance >= msg.value, "Not enough balance in the contract");


        bool result = getRandomResult();
        if (result) {
            // If the result is heads, the player wins and receives double the bet amount
            payable(msg.sender).transfer(msg.value * 2);
            contractBalance -= msg.value * 2;
        } else {
            // If the result is tails, the player loses and the contract balance increases by the bet amount
            contractBalance += msg.value;
        }
    }

    function getRandomResult() private view returns (bool) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
        return (random == 1);
    }

    // function setBetAmount(uint256 amount) public {
    //     require(amount > 0, "Bet amount must be greater than 0");
    //     betAmount = amount;
    // }

    function withdrawFunds() public {
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        payable(msg.sender).transfer(contractBalance);
        contractBalance = 0;
    }
}