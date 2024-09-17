// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract DelegateCall {
    uint public num1; // 位于 slot 0

    function setNumber(uint _num) external  {
        num1 = _num;
    }

}


/*
    代理调用，会调用其他合约的函数来修改自己的状态，此时状态需要保证同一个插槽（名字其实是否一样无所谓）
*/
contract TestCall {
    uint public num2; // 位于 slot 0
    function test(address addr, uint _num) external {
        // 除了 abi.encodeWithSignature 方式调用外，还可以使用 abi.encodeWithSelector，相比较而言，不会出现拼错的情况
      (bool success, bytes memory _data) =  addr.delegatecall(abi.encodeWithSelector(DelegateCall.setNumber.selector, _num));
      require(success, "delegatecall failed");
    }
}