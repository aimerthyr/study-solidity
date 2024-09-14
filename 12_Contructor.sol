// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Constructor {
    address public owner;
    uint public num;

    // 构造函数只会在合约创建的时候调用一次，后续不会再调用
    constructor(uint _num) {
        owner = msg.sender;
        num = _num;
    }
}