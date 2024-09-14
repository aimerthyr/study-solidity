// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
contract FunctionIntro {
    /*
        函数会有不同的修饰符，例如这里的 external 代表内外部都可以调用  pure 代表纯函数（即既不会读取合约中的变量，也不会修改） returns 后面跟的是返回值的类型
        具体一些细节后面会更加详细的了解
    */
    function add(uint a, uint b) external pure returns(uint) {
        return a + b;
    }

    function sub(uint a, uint b) external  pure  returns(uint) {
        return a - b;
    }
}