// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract OverflowToken {
    mapping(address => uint256) public balances;

    constructor() public {
        // Дамо відправнику 100 токенів
        balances[msg.sender] = 100;
    }

    // Уразлива функція передачі токенів
    function transfer(address _to, uint256 _value) public {
        require(balances[msg.sender] >= _value, "Not enough tokens");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
}
