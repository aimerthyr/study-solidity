// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Mapping {
    mapping(address => uint) public  balances;

    function foo() external {
        // 通过中括号的形式设置值，同时也是通过中括号的形式获取值
        balances[msg.sender] = 100;
        uint bal1 = balances[address(1)]; // 0 映射中不存在的key 返回的值都是 这个值类型的默认值
        delete  balances[msg.sender]; // 并没有删掉这个key 而是将其改为默认值
    }
}