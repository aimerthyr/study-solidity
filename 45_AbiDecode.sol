// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


contract AbiDecode {
    struct Person {
        uint age;
        uint[2] car;
    }

    // 编码
    function encode(uint x, address addr, bool y, Person memory p) external pure returns(bytes memory)  {
        return abi.encode(x, addr, y, p);
    }

    function encodePacked(uint x, address addr, bool y) external pure returns(bytes memory)  {
        return abi.encodePacked(x, addr, y);
    }

    // 解码
    function decode(bytes memory data) external pure returns(uint x, address addr, bool y, Person memory p) {
        (x, addr, y, p) =  abi.decode(data, (uint , address, bool, Person));
    }

    // 无法解析，因为 encodePacked 会压缩，导致数据格式无法区分
    function decodePacked(bytes memory data) external pure returns(uint x, address addr, bool y) {
        (x, addr, y) =  abi.decode(data, (uint , address, bool));
    }
}