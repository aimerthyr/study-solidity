// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract FunctionReturns {
    // 如果某个函数，内部外部都需要使用，则用public 如果是 external ，内部使用需要用 this，并且会产生额外的 gas
    function returnMany() public pure returns (uint , bool) {
        return (1, false);
    }

    function returnNameMany() public pure returns(uint num, bool flag) {
        return (2, true);
    }

    // 如果在 returns 指定了变量，那么函数执行完，会自动将指定的变量 return 出去
    function returnValue() public pure returns(uint num, bool flag) {
        num = 10;
        flag = false;
    }


    function assignValue() public pure {
        (uint x, bool y) = returnMany();
        // 在使用函数中的返回值时，不需要保证和返回的变量名一样
        (uint num1, bool flag1) = returnNameMany();
        // 如果不需要使用某个返回值，可以空着
        (, bool z) = returnValue();
    }

}