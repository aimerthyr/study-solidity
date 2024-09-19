// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract FunctionSelector {
    event Log(bytes data);

    // "foo(address,uint256)"
    function getFunctionSelector(string calldata funcName) external pure returns(bytes4) {
        return bytes4(keccak256(abi.encodePacked(funcName)));
    } 

    function foo(address _to, uint _num) external {
        /*
            打印这次调用的 data 
            0xbd0d639f0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4000000000000000000000000000000000000000000000000000000000000000c
            将其分解开来
            这个是函数的签名(默认取前四个字节) =>   0xbd0d639f
            这个是后面的参数 =>   0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4000000000000000000000000000000000000000000000000000000000000000c
        */
        emit Log(msg.data);

    }
}