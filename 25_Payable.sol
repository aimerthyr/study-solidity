// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Payable {
    // 如果给某个地址类型加上payable 那么该地址就拥有了转账和接收代币的能力
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    // 如果想调用某个函数，并且转账，则需要设置 payable 否则会报错
    function deposit() external payable  {}

    function getBalance() external view returns (uint256) {
        // 获取当前合约中的余额
        return address(this).balance;
    }
}
