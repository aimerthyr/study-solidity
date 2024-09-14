// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract StateVariables {
    // 定义在合约顶层的变量都是状态变量，会永久地写在区块链中
    uint public num = 100;

    function foo() external pure {
        // 局部变量，函数调用结束后就会被释放
        uint num1 = 200;
    }
}