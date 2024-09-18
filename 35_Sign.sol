// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/*
    签名步骤
    1. 对消息进行哈希运算
        bytes32 messageHash = keccak256(abi.encodePacked(data));
    2. 在前端进行签名 account 代表账户地址 （web3js底层会通过账户地址，找到你的私钥，一般存放于钱包中，然后再将其进行签名） 
        const signature = await web3.eth.personal.sign(messageHash, account);
    3. 在合约中验证签名（就是判断 account 和你最后恢复出来的签名地址是否一样）
*/
contract Sign {
    // 获取哈希运算后的消息
    function getMessageHash(string memory data) public  pure returns (bytes32) {
        return keccak256(abi.encodePacked(data));
    }

    // 获取以太坊标准的哈希运算消息（可以理解成拼接上以太坊标准的固定前缀，然后取了第二次哈希）
    function getEthSignedMessageHash(bytes32 messageHash) public  pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            messageHash
        ));
    }

    // 获取签名中的 v,r,s，这三个值是构成签名的组成部分
    function getVRS(bytes memory signature) private pure returns (uint8 v, bytes32 r, bytes32 s)  {
        assembly {
            r := mload(add(signature,32))
            s := mload(add(signature,64))
            v := byte(0, mload(add(signature, 96)))
        }
    }

    // 我们将签名的地址，原始信息，以及签名传入
    function verify(address signer, string memory message, bytes memory signature) external pure returns (bool) {
        // 将原始信息做一次哈希
        bytes32 messageHash = getMessageHash(message);
        // 按照以太坊标准再做一次哈希
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        // 这里的signature = 链下生成好的签名（这里的签名，会用哈希后的信息 messageHash 和 signer 进行签名，即开头注释中的第二步）
        (uint8 v, bytes32 r, bytes32 s) = getVRS(signature);
        // 最后复原出签名地址，看一下是否和传入的地址相同
        return ecrecover(ethSignedMessageHash, v, r, s) == signer;
    }


}