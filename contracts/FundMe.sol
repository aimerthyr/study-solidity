// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "../librarys/Convert.sol";

contract FundMe {
    using Convert for uint256; // 让 uint256 拥有 Convert 中的方法
    uint constant MIN_DEPOSIT = 10 * 1e18; // 最小的存款金额是 10 usd(美元) 然后需要统一成 18 小数
    address payable  immutable owner;
    address[] depositors;
    mapping (address => uint) depositMap;

    constructor(){
        owner = payable(msg.sender);
    }

    modifier isOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    // 存款
    function deposit() payable  public  {
        // 但是用户发送的是 以太币（所有的交易都会用 wei 来计算） ,我们如何做转换成美元，这个时候就需要使用 chainlink 来于外部世界交互
        require(msg.value.convertToDollars() > MIN_DEPOSIT, "you do not have enough money");
        depositors.push(msg.sender);
        depositMap[msg.sender] = msg.value;
    }

    function withDraw() external isOwner {
        uint length = depositors.length;
        for(uint i =0; i < length; ++i) {
            depositMap[depositors[i]] = 0;
        }
        (bool callSuccess, ) = owner.call{ value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    // 如果直接向合约发送转账，不携带数据（例如通过 transfer、send 或不带数据的 call）则会调用 receive，必须是 payable
    receive() external payable { 
        deposit();
    }

    // 在调用未知或未定义的函数时被触发,可以不是 payable
    fallback() external payable {
        deposit();
    }
}