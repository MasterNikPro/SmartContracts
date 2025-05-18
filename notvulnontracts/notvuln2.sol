
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeToken {
    string  public constant name     = "VerySafeToken";
    string  public constant symbol   = "VST";
    uint8   public constant decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor() {
        totalSupply = 1_000 * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to]        += _value;

        return true;
    }
}
