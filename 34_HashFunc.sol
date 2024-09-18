// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract HashFunc {
    // keccak256 返回值是固定的 bytes32
    function hashByEncode(string calldata str1, string calldata str2) external pure returns (bytes32)  {
        // abi.encode 每个输入数据有自己的边界，不会混合，更安全
        return keccak256(abi.encode(str1, str2));
    }

    function hashByEncodePacked(string calldata str1, string calldata str2) external pure returns (bytes32)  {
        // abi.encodePacked 数据会被压缩，可能发生混合，出现哈希冲突，例如 "AAA" "BB" 和 "AA" "ABB" 这两组数据 encodePacked 之后的值是相同的
        return keccak256(abi.encodePacked(str1, str2));
    }
}