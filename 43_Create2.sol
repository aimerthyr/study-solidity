// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Test1 {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

contract Creat2Test {
    // 获取测试合约的字节码
    function getByteCode() view  external returns(bytes memory) {
        return abi.encodePacked(type(Test1).creationCode, abi.encode(msg.sender));
    }

    // 部署（加盐，为了让部署地址可以提前预测（不加的话，默认会使用nounce，而nouce是不停变化的））
    function deploy(uint _salt) external returns(Test1)  {
        Test1 _contract = new Test1{ salt: bytes32(_salt)}(msg.sender);
        return _contract;
    }

    // 用于验证加盐后的地址是不是可以被预测的
    function getAddress(bytes memory bytecode, uint _salt) external  view returns (address) {
        return address(uint160(uint(keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))))));
    }
}