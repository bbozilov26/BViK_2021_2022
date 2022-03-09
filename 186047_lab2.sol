// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title 186047_lab2
 * @dev Store & retrieve Person on specific address
 */

contract Person_Lab2{

    struct Person{
        string firstName;
        string lastName;
    }

    mapping (address => Person) public peopleAddresses;

    function addPerson(string memory fName, string memory lName) public{
        peopleAddresses[msg.sender] = Person(fName, lName);
        emit newPersonEvent(msg.sender, fName, lName);
    }

    function getPerson(address personAddress) public view returns (Person memory){
        return peopleAddresses[personAddress];
    }

    event newPersonEvent(address personAddress, string fName, string lName);
}