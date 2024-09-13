// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract ValueTypes {
    bool public flag  = true;
    // uint 正整数 默认是 uint256 0~2*256-1 (uint8 0~2*8-1)
    uint public num1 = 200;
    // 整数 -2*255～2*255-1
    int public num2 = -100;
    // 默认是十进制的，可以通过 0x来指定16进制或者 0b指定二进制
    uint public num3 = 0x1f;
    // type(类型).min 代表获取当前类型的最小值，同理 type(类型).max 获取的就是最大值
    int public num4 = type(int).min;
    uint public num5 = type(uint).max;
    address public add = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    // 字节数组（后面的数字，就代表能存放几个字节，例如bytes8 代表能存放八个字节）
    bytes8 public list = 0x5B38Da6a701c5685;
}