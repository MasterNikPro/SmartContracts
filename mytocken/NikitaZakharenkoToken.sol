// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NikitaZakharenkoToken {
    string public name = "NikitaZakharenkoToken";
    string public symbol = "NZT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    event ContractDeployed(address owner, uint256 supply);

    constructor(uint256 _initialSupply) {
    require(_initialSupply > 0, "Initial supply must be greater than zero");
    owner = msg.sender;
    totalSupply = _initialSupply * 10 ** uint256(decimals);
    balanceOf[owner] = totalSupply;
    emit ContractDeployed(owner, totalSupply);
    }  
    function _isOddDate() internal view returns (bool) {
        uint256 day = (block.timestamp / 86400) % 30 + 1; 
        return day % 2 != 1;
    }
    function checkDate() public view returns (uint256, bool) {
    uint256 day = (block.timestamp / 86400) % 30 + 1; 
    return (day, day % 2 != 1);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_isOddDate(), "Transfers allowed only on odd dates");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_isOddDate(), "Transfers allowed only on odd dates");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
