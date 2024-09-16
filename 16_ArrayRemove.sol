// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract ArrayRemove {
    uint[] public arr = [1,2,3,4];

    function remove(uint index) public   {
        require(index >=0 && index < arr.length);
        // 从开始下标的位置，开始一直让下一个值等于当前值，然后最后再把多的值pop出去
        for(uint i = index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }
}