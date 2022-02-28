// SPDX-License-Identifier: UNLICENCED

pragma solidity >=0.7.0 <0.9.0;

contract HelloWorld {
    string public greet = "Hello World!";

    function update (string memory newGreet) public {
        greet = newGreet;
    }
}