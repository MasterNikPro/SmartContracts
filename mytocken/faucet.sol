// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address public owner;
    IERC20 public token;

    uint256 public withdrawalAmount = 50 * (10**18);
    uint256 public lockTime = 1 minutes;

    event Withdrawal(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) private nextAccessTime;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
        owner = msg.sender;
    }

    function requestTokens() public {
        require(msg.sender != address(0), "Invalid address");
        require(token.balanceOf(address(this)) >= withdrawalAmount, "Insufficient faucet balance");
        require(block.timestamp >= nextAccessTime[msg.sender], "Wait before requesting again");

        nextAccessTime[msg.sender] = block.timestamp + lockTime;
        require(token.transfer(msg.sender, withdrawalAmount), "Token transfer failed");

        emit Withdrawal(msg.sender, withdrawalAmount);
    }

    function depositTokens(uint256 amount) public {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(token.allowance(msg.sender, address(this)) >= amount, "Approve tokens first");

        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        emit Deposit(msg.sender, amount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawalAmount(uint256 amount) public onlyOwner {
        withdrawalAmount = amount * (10**18);
    }

    function setLockTime(uint256 minutes_) public onlyOwner {
        lockTime = minutes_ * 1 minutes;
    }

    function withdraw() external onlyOwner {
        uint256 contractBalance = token.balanceOf(address(this));
        require(contractBalance > 0, "No tokens available for withdrawal");

        require(token.transfer(owner, contractBalance), "Token transfer failed");
        emit Withdrawal(owner, contractBalance);
    }
}
