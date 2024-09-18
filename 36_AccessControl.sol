// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract AccessControl {
    // 定义一个角色的 映射 使用 bytes32作为key 而不是直接使用字符串，是因为更节约 gas
    mapping(bytes32 => mapping(address => bool)) public roles;

    // 定义两个 哈希运算后的角色 key
    // 0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    // 0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));

    constructor() {
        _grantRole(msg.sender, ADMIN);
    }

    // 定义一个授予角色的事件向外广播
    event GrantRole(address indexed person, bytes32 indexed role);
    // 定义一个取消角色的事件向外广播
    event RevokeRole(address indexed person, bytes32 indexed role);

    // 私有的授权方法不需要鉴权，可以给内部使用
    function _grantRole(address person, bytes32 role) private {
        roles[role][person] = true;
        emit GrantRole(person, role);
    }

    modifier onlyRole(bytes32 role) {
        // 只有当前这个人，具有某个角色的权限才可以
        require(roles[role][msg.sender], "no permission");
        _;
    }

    function grantRole(address person, bytes32 role) external onlyRole(ADMIN) {
        _grantRole(person, role);
    }

    // 取消角色
    function revokeRole(address person, bytes32 role) external onlyRole(ADMIN) {
        roles[role][person] = false;
        emit RevokeRole(person, role);
    }
}
