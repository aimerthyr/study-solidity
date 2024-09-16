// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/*
    constant 和  immutable 区别
    constant 必须在声明时赋值 而 immutable 可以在声明或者构造函数中赋值（但不能在其他地方赋值）
    使用场景
    使用 constant 时，适合那些在编译时已经知道的值，且在合约的整个生命周期中不会改变的值。
    使用 immutable 时，适合那些在部署时由外部条件决定的值，且一旦部署后就不再变化的变量。
*/
contract Immutable {
    // 351 gas 不可修改的常量，减少很多 gas 费
    address public immutable addr1 = msg.sender;
    // 2485 gas
    address public addr2 = msg.sender;

    address public immutable addr3;

    constructor(){
        addr3 = msg.sender;
    }
}