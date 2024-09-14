// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// 一个简单的控制权限的合约
contract Owner {
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'only owner can call');
        _;
    }

    // 设置拥有者
    function setOwner(address newAddr) external  onlyOwner {
        require(newAddr != address(0));
        owner = newAddr;
    }

    // 仅拥有者可以调用
    function onlyOwnerFuncion() external  onlyOwner {

    }

}