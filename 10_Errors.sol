// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Errors {
    function testRequire(uint num) external pure {
        // 第一个参数是判断条件，如果条件符合，才会继续往下执行。第二个描述信息，如果报错信息越长，则消耗的 gas 费用越高
        require(num > 10, unicode'num必须大于10num必须大于10num必须大于10num必须大于10num必须大于10');
    }

    function testRevert(uint num) external  pure {
        if(num < 10) {
            // 可以提供报错信息
            revert(unicode'num必须大于10');
        }
    }

    function testAssert(uint num) external  pure {
        // 满足这个条件，才能往下执行
        // 只能有一个参数，并且无法提供报错信息
        assert(num > 10);
    }

    // 自定义错误 可以设置参数
    error CustomError(address sender, string errorMsg);

    function testCustomError(uint num) external  view {
        if(num < 10) {
            // 需要通过 revert 调用
            revert CustomError(msg.sender, 'error');
        }
    }
}