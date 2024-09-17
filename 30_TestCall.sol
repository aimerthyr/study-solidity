// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract TestCall {
    string public message;
    uint public x;
    event Log(string message);

    fallback() external {
        emit Log("fallback trigger");
    }

    receive() external payable { }

    function foo(string memory _message, uint _x) external  payable  returns(bool, uint) {
        message = _message;
        x = _x;
        return (true, 9999);
    }
}


contract Test {
    bytes public  data;
    function testFoo(address  addr, string calldata message, uint  x) external payable   {
        // 如果用call去调用，参数中是uint的话，需要写完整为uint256 否则会报错
        (bool success, bytes memory _data) = addr.call{ value: 200 }(abi.encodeWithSignature("foo(string,uint256)", message, x));
        require(success, "call failure");
        data = _data;
    }
}