// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Event {
    // 定义时间，外部可监听及检索
    event Log(string message, uint val);

    // 事件中最多可以有三个索引，索引是为了方便在以太坊浏览器或者一些其他工具监听的时候可以做快速检索
    event IndexedLog(address indexed sender, uint val);

    function foo() external  {
        emit Log("foo", 100);
    }

    function bar() external {
        emit IndexedLog(msg.sender, 200);
    }
}