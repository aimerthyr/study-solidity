// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// modifier 常用于封装相同逻辑,可以多个一起使用，按照先后顺序进入修改器
contract Modifier {
    uint public num = 10;

    // 当某个函数被修改器装饰之后，那个函数在执行的时候，会首先进入修改器（可以接收参数，也不可以不接收）
    modifier limit(uint x) {
        require(x>5);
        // _代表原先函数的函数体内容，可以放在执行器的任意位置
        _;
        // 执行其他代码也可以
    }


    function add(uint x) external limit(x)  {
        num++;
    }

    function sub(uint x) external limit(x) {
        num--;
    }

}