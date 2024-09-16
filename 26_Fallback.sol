// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Fallback {
    event Log(string);
    /*
        合约接收的调用包含了 msg.data，且没有找到与之对应的函数签名。
		合约没有 receive() 函数，且接收到 Ether（不管是否带有 msg.data）。
		fallback() 函数可以处理所有无法匹配的函数调用，即使它们不涉及 Ether 转账。
    */
    fallback() external payable {
        emit Log("fallback trigger");
    }

    /*
    	合约接收 Ether，且调用不包含 msg.data（即纯粹发送 Ether 时，如 transfer 或 send）。
		合约必须定义了 receive() 函数，且函数必须为 payable。
    */
    receive() external payable {
        emit Log("receive trigger");
    }
}