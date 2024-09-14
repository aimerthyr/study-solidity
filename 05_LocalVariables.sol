// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract LocalVariables {
    uint public num;
    bool public flag;
    address public addr;

    // 
    function foo() external  {
        uint num1 = 10;
        bool flag1 = false;
        // 假设这里经过了很多的代码执行
        // 局部变量的修改，当函数执行完，就结束了，不会保存到链上
        num1 = 20;
        flag1 = true;

        // 可以通过调用函数对状态变量进行修改
        num = 100;
        flag = true;
        addr = address(10);
    }
}