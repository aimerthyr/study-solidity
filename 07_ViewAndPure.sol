// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract ViewAdnPure {
    uint public num = 10;

    // 当读取了状态变量时，需要标记为 view
    function viewFunc() external view returns(uint) {
        return num;
    }

    // 没有读取任何变量，仅仅是函数内部的变量，则需要标记为 pure
    function pureFunc() external  pure returns (uint) {
        return 1;
    }

    // 举例1
    function addToNum(uint num1) external view returns(uint) {
        return num + num1;
    }

    // 举例2
    function add(uint x, uint y) external pure returns(uint) {
        return x + y;
    }

    // 如果希望修改状态变量，则什么都不指定就可以了
    function changeNum(uint num1) external {
        num = num1;
    }
}
