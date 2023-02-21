// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Owner.sol";

contract Manager is Owner {
    bool private stopped = false;

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

    // Return the contract balance
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}