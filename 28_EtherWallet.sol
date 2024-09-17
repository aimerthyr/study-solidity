// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// 一个简单的钱包合约
contract EtherWallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    receive() external payable { }

    modifier onlyOwner() {
        require(msg.sender == owner, "sender is not owner");
        _;
    }

    function withDraw(uint amout) external onlyOwner  {
        payable(msg.sender).transfer(amout);
    }

    function getBalance() external  view returns (uint) {
        return address(this).balance;
    }
}