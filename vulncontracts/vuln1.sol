// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint) public balances;

    // Function to deposit ether
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Vulnerable withdraw function
    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Send the ether to the caller
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // Update balance after sending (vulnerability here)
        balances[msg.sender] -= _amount;
    }

    // Helper to check balance
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}
