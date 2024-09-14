// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Constants {
    /*
        如果一个值是不能修改的，那么可以用constant修饰，并且变量名大写且用_相连
        好处是可以减少很多 gas 费用，例如这里 读取 MY_ADDRESS 耗费了 351 gas
    */
    address public constant MY_ADDRESS = address(100);
    // 读取 addr 耗费了 2507 gas
    address public addr =address(100);
}
