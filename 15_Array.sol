// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


contract Array {
    uint[] public arr = [1,2];
    uint[4] public arr1 = [1,2,3,4];


    function foo() external {
        arr.push(3); // [1,2,3];
        uint num = arr[2]; // 3
        arr[1] = 77; // [1,77,3]
        delete arr[1]; // [1,0,3]
        arr.pop(); // [1,0];
        uint length = arr.length; // 2
    }

    // 函数内部如果需要声明复杂类型，则需要指定其存储环境 memory 代表仅在内存中，调用完就会释放
    function bar() external pure returns(uint[] memory, uint[4] memory)  {
        // 1. 创建一个动态数组（不可以设置初始值，可通过循环进行赋值）
        uint[] memory list = new uint[](2);
        // 2. 创建一个固定长度数组（uint 默认是256 所以需要在设置值的时候强制指定第一项类型）
        uint[4] memory list2 = [uint256(4),3,2,1];
        return (list, list2);
    }
}