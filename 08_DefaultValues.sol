// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// 每个类型变量，在没有赋值的时候都是有默认值的
contract DefaultValues {
    bool public flag; // false
    uint public num; // 0
    int public num1; // 0
    // 地址是 160 位的 然后用16进制表示，一个16进制的数是4位 所以一共是 160/4 = 40 个 0
    address public addr; // 0x0000000000000000000000000000000000000000
    // bytes32 代表32个字节，也就是32*8 = 256位 用16进制表示 256/4 = 64 个 0
    bytes32 public bt; // 0x0000000000000000000000000000000000000000000000000000000000000000
}
