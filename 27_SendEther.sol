// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


contract SendEther {
    // 如果需要 deploy 的时候就存入代币，那么需要给 constructor 设置 payable
    constructor() payable  {}

    receive() external payable { }

    function sendByTransfer(address payable  to) external {
        // 给接收方提供 2300 gas, 如果失败，会抛出异常并回滚交易,并且不能传递数据
        to.transfer(100);
    }


    function sendBySend(address payable to) external {
        // 给接收方提供 2300 gas，如果失败，不会抛出异常，而是返回 false，需要手动处理失败逻辑，并且不能传递数据
        bool success = to.send(100);
        require(success, "send failure");
    }

    string public resultStr;
    function sendByCall(address payable to) external {
        // 会把当前剩余的 gas 全部传递过去，返回布尔值，指示是否成功，需要手动处理失败情况。（但是需要注意安全性），但可以传递数据
        // 例如这里还希望调用对方合约中的 foo 那么由于有转账，所以对方foo函数必须要是 payable
        (bool success, bytes memory returnData) = to.call{value: 100}(abi.encodeWithSignature("foo()"));
        require(success, "send failure");
        // 将对方函数里的结果进行解码 第一个参数是值，第二个参数是要解码成什么格式
        resultStr = abi.decode(returnData, (string));
    }
}


contract ReceiveEther {

    function foo() external payable returns (string memory)  {
        return "I am foo function";
    }

    receive() external payable { }
}