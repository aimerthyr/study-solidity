// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract A {
    uint num;
    constructor(uint _num) {
        num = _num;
    }
}

contract B {
    bool flag;
    constructor(bool _flag) {
        flag = _flag;
    }
}

// 如何一个合约继承其他合约，那么构造函数的执行顺序，是按照继承顺序来的
contract C is A, B {
    // 继承了几个，就写几个
    constructor(uint _num, bool _flag) A(_num) B(_flag) {}
}