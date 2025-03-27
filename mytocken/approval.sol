// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
}
contract Approval {
    constructor(address faucetAddress) payable {
       approve(faucetAddress, 1000);
    }
}