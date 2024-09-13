// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21; // ^ 代表 0.8.21 以上的所有版本都可以被编译（不能是0.9.x）

contract HelloSolidity {
    // public修饰的变量 合约编译完成后，就会自动生成一个getter函数（类似于 => str() ），在调试中会显示成一个蓝色的按钮（蓝色代表的是只读）
    string public str = "Hello Solidity";
}