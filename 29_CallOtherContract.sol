// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract CallOtherContact {

    function setX(address addr, uint _x) external  {
        // 1.第一种调用 将地址传入合约名中，生成实例
        OtherContract(addr).setX(_x);
    }

    // 2. 直接将参数类型约定为合约，自动初始化实例
    function setX1(OtherContract addr, uint _x) external  payable {
        addr.setX(_x);
    }

    function setValue2(address addr) external  payable {
        // 调用函数并进行转账
        OtherContract(addr).setValue{ value: msg.value }();
    }


}


// 其他合约，用于被调用
contract OtherContract {
    uint public x;
    uint public value;


    function setX(uint _x) external {
        x = _x;
    }

    function setValue() external payable  {
        value = msg.value;
    }

}