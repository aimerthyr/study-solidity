// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable  {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;

    function createAccount(address _owner) external payable  {
        // 通过工厂函数创建合约
        Account account = new Account{ value: msg.value }(_owner);
        accounts.push(account); 
    }
}