// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract SaveGas {
    uint public total;
    
    /*
        [1,2,3,4,5,100]
        初始化 gas 50759
    */
    function sum(uint[] memory nums) external  {
        for(uint i = 0; i< nums.length; i+=1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if(isEven && isLessThan99) {
                total += nums[i];
            }
        }
    }

    /*
        优化gas
        1. memory => calldata  49051
        2. i+=1 => ++i（比 i++ 更节约，因为 i++ 需要先保存一份值） 47977
        3. isEven && isLessThan99 => 合并到一起，利用短路运算 47671
        4. total += nums[i] => 利用临时变量，最后统一赋值 47461
        5. nums[i] => 提前获取 47293
        6. nums.length => 提前获取 47257

    */
    function optimizeSum(uint[] calldata nums) external  {
        uint _total = total;
        uint length = nums.length;
        for(uint i = 0; i< length; ++i) {
            uint num = nums[i];
            if( num % 2 == 0 &&  num < 99) {
                _total += num;
            }
        }
        total = _total;
    }
}