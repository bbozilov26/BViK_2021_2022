// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Owner.sol";

contract Manager is Owner {
    bool private stopped = false;
    uint public maxBetETH = 20 ether;
    uint public minBetETH = 0.2 ether;
    // uint public betFeeETH = 0.2 ether;
    uint randomNonce = 0;

    // Stop or unstop contract
    function toggleContractActive() public isOwner {
        stopped = !stopped;
    }

    modifier stopInEmergency {
        require(!stopped);
        _;
    }
    modifier onlyInEmergency {
        require(stopped);
        _;
    }

    // Allow contract owner to deposit funds
    // function deposit(uint256 _userDepositAmount) external payable isOwner stopInEmergency {
    //     require(_userDepositAmount > 0, "Deposit must be greater than 0.");
    // }

    // Return the contract balance
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    // function setBalance(uint256 _contractBalance) public {
    //     address(this).balance = _contractBalance;
    // }

    // Transfer funds to the contract owner
    // function withdraw() external isOwner onlyInEmergency {
    //     payable(msg.sender).transfer(address(this).balance);
    // }

    // Generate a random number with keccak256 hash function
    // function randomNumber(uint _modulus) internal returns(uint) {
    //     randomNonce++;
    //     // This is not the most secure way to generate a random number. For demonstration purposes only
    //     return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randomNonce))) % _modulus;
    // }

    // Change the minimum amount of the bet
    function setMinBet(uint256 _newAmount) external isOwner stopInEmergency {
        // Convert ETH amount to WEI
        minBetETH = _newAmount * 10 ** 18;
    }

    function getMinBet() public view returns (uint256){
        return minBetETH;
    }

    // Change the maximum amount of the bet
    function setMaxBet(uint _newAmount) external isOwner stopInEmergency {
        // Convert ETH amount to WEI
        maxBetETH = _newAmount * 10 ** 18;
    }

    function getMaxBet() public view returns (uint256){
        return maxBetETH;
    }

    // Change the bet fee
    // function setBetFee(uint _newFee) external isOwner stopInEmergency {
    //     // Convert ETH amount to WEI
    //     betFeeETH = _newFee * 10 ** 18;
    // }
}