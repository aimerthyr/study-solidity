// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract A  {
    // 如果一个函数希望被子合约所重写，则需要设置 virtual
    function foo() external pure virtual  returns(string memory) {
        return 'A';
    }

    function bar() external  pure virtual returns(string memory) {
        return 'A';
    }
}

contract B is A {
    // 如果子合约中还希望被孙合约重写，则同样需要设置 virtual
    function foo() external  pure virtual  override  returns(string memory) {
        return 'B';
    }
    function baz() external  pure returns(string memory) {
        return 'B';
    }
}

contract C is B {
    function foo() external  pure override  returns(string memory) {
        return 'C';
    }
}
