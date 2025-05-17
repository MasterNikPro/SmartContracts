// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


contract OverflowToken {
    string  public constant name     = "VeryBadToken";
    string  public constant symbol   = "VBT";
    uint8   public constant decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor() public {
        totalSupply = 1_000 * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;      
    }

    
    function transfer(address _to, uint256 _value) public returns (bool) {
        balanceOf[msg.sender] -= _value;   // <-- underflow
        balanceOf[_to]        += _value;   // <-- overflow
        return true;
    }
}
