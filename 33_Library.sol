// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// 库合约，用于代码复用
library ArrayLib {
    function find(uint[] storage arr, uint num) internal  view returns (uint) {
        for(uint i =0; i< arr.length; i++) {
            if(arr[i] == num) {
                return i;
            }
        }
        revert("not found");
    } 
}


contract TestArray {
    // 使用 ArrayLib 来拓展数组的方法
    using ArrayLib for uint[];

    uint[] public arr = [1,2,3,4];

    function findIndex(uint num) external view returns (uint) {
        // 1. 使用拓展方法，但是需要搭配 using
        return arr.find(num);
        // 2. 直接使用库合约
        // return ArrayLib.find(arr, num);
    }
}