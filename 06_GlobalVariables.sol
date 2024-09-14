// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
contract GlobalVariables {
    /*
        如果你的函数当中没有修改状态变量，但是需要读取变量，则需要指定为 view 这是一个好的最佳实践，需要保证
        为什么要使用 view？
        1. 降低 gas 成本：标记为 view 的函数可以在合约外部调用时避免 gas 消耗，因为它们不修改链上状态。
        2. 增强代码可读性：明确标识哪些函数只读取数据，哪些函数会修改状态，使代码更易于理解和维护。
        3. 提升安全性：有助于确保函数不会意外修改状态变量。
    */
    function globalVars() external view returns (address, uint, uint) {
        // 代表调用合约的地址（可能是某个外部账户也可能是其他合约）
        address sender = msg.sender;
        // 代表的包含当前交易的那个区块的时间戳
        uint timestamp = block.timestamp;
        // 代表当前区块的编号
        uint blockNum = block.number;
        return (sender, timestamp, blockNum);
    }
}