// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract VeryNaiveAuction {
    address public highestBidder;
    uint256 public highestBid;
    mapping(address=>uint256) public pendingReturns;
    uint256 public immutable auctionEnd;
    constructor(uint256 _sec){ auctionEnd = block.timestamp + _sec; }
    function bid() external payable {
        require(block.timestamp < auctionEnd, "ended");
        require(msg.value > highestBid, "too low");
        if(highestBid!=0) pendingReturns[highestBidder] += highestBid;
        highestBidder = msg.sender;
        highestBid    = msg.value;
    }
    function withdraw() external {
        uint a = pendingReturns[msg.sender];
        require(a>0,"0");
        pendingReturns[msg.sender]=0;
        payable(msg.sender).transfer(a);
    }
}
