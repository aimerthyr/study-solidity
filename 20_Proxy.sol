// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Proxy {
    event Deploy(address);

    fallback() external payable {}

    function deploy(bytes memory _code) external payable returns (address addr) {
        assembly {
            // create(v, p, n)
            // v = amount of ETH to send
            // p = pointer in memory to start of code
            // n = size of code
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }
        // return address 0 on error
        require(addr != address(0), "deploy failed");

        emit Deploy(addr);
    }

    // _target 某个合约的地址 _data 代表你要执行哪个操作的字节码
    function execute(address _target, bytes memory _data) external payable {
        (bool success, ) = _target.call{value: msg.value}(_data);
        require(success, "failed");
    }
}

contract TestContract1 {
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}

contract TestContract2 {
    address public owner = msg.sender;
    uint public value = msg.value;
    uint public x;
    uint public y;

    constructor(uint _x, uint _y) payable {
        x = _x;
        y = _y;
    }
}

contract Helper {
    function getBytecode1() external pure returns (bytes memory) {
        // 用于获取部署合约 TestContract1 的字节码
        bytes memory bytecode = type(TestContract1).creationCode;
        return bytecode;
    }

    function getBytecode2(uint _x, uint _y) external pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract2).creationCode;
        // 将需要部署的字节码和传入的参数，进行紧凑编码
        return abi.encodePacked(bytecode, abi.encode(_x, _y));
    }

    function getCalldata(address _owner) external pure returns (bytes memory) {
        /*
        将 setOwner(address) 这个函数调用及其参数 _owner 编码成一种称为ABI 编码的格式。
        这种编码可以让其他合约通过 call 等方式进行调用
        */
        return abi.encodeWithSignature("setOwner(address)", _owner);
    }
}
