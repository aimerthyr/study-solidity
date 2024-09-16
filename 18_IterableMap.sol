// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract IterableMapping {
    // mapping是不可以遍历的，通常需要搭配数组来实现来进行遍历的需求
    mapping(address => uint) public balances;
    mapping(address => bool) public inserted;

    address[] public list;

    function set(address _addr, uint value) external  {
        balances[_addr] = value;
        if(!inserted[_addr]) {
            inserted[_addr] = true;
            list.push(_addr);
        }
    }

    function first() external view returns(uint) {
        return balances[list[0]];
    }

    function last() external  view returns(uint) {
        return balances[list[list.length - 1]];
    }


    function getItem(uint index) external view returns(uint) {
        return balances[list[index]];
    }
}