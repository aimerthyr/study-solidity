// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// 正常情况下，就算你非常快的同时调用 foo1 和 foo2 ，也不能保证两次调用会被同一个区块打包，也就是 block.timestamp 不会是一样的
contract Call {
    function foo1() public view  returns(uint, uint) {
        return (1, block.timestamp);
    }

    function foo2() public view  returns(uint, uint) {
        return (2, block.timestamp);
    }

    function getFoo1Bytecode() external pure returns(bytes memory) {
        // 特别注意的是 获取函数签名是 需要指定 this
        return abi.encodeWithSelector(this.foo1.selector);
    }

    function getFoo2Bytecode() external pure returns(bytes memory) {
        // 特别注意的是 获取函数签名是 需要指定 this
        return abi.encodeWithSelector(this.foo2.selector);
    }
}

contract MutiCall {
    // _targets 代表调用地址的数组 _data 代表调用时的数据
    function mutiCall(address[] calldata _targets, bytes[] calldata _data) view external returns(bytes[] memory)  {
        require(_targets.length == _data.length, "call failed");
        bytes[] memory result = new bytes[](_targets.length);
        for(uint i = 0; i< _targets.length; i++) {
            // 被 staticcall 的调用的函数不会修改区块链状态，如果你单纯只是想读取其他合约的状态，那么就使用 staticcall
            (bool success, bytes memory _res) = _targets[i].staticcall(_data[i]);
            require(success, "call failed");
            result[i] = _res;
        }
        return result;
    }
}