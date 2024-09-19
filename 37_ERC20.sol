// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/*
    在 ERC-20 标准诞生之前，开发人员可以自由创建和部署他们自己的代币，但由于没有统一的标准，不同代币的实现方式和功能可能差异很大。这导致了以下问题：
	1.	互操作性差：不同的代币合约往往有不同的接口和功能，导致开发工具、钱包、交易所等无法与所有代币进行有效交互。
	2.	开发难度大：每个项目都需要重新编写代币合约的逻辑，缺乏通用的框架。这增加了开发成本和复杂性。
	3.	使用体验不一致：不同代币的交互方式可能不同，用户体验不统一。比如，用户在转移一种代币时使用的方法可能与另一种代币完全不同，导致混乱
*/
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
       定义一个事件，记录从某个地址，向某个地址发送了多少代币 
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
       某个账户（owner）允许另一个账户（spender）可以使用自己的一定数量的代币（value）
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
        表示当前合约内所有账户的持币综合
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
        获取某个账户的余额
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
        表示调用者可以将自己的代币(value)发送给某个地址（to）
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
        用于查询代币持有者（owner）授权其他账户（spender）可以代表自己消费的代币数量
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
        表示允许代币持有者（调用函数的人）授权另一个账户（spender）可以使用自己账户中的一定数量的代币（value）
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
        它允许一个账户（spender）使用 approve 授权的代币额度，从另一个账户（from）转移代币给第三方（to）。这是 ERC-20 代币标准的一部分，用于代币持有人授权他人代替自己进行转账的场景
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// 简易实现，里面有很多权限和边界还没有设定
contract MyERC20 is IERC20 {
    // 代币总量
    uint public totalSupply;
    // 记录账户余额的账本
    mapping(address => uint) _balanceOf;
    // 记录某个账户允许给其他账户，使用自己代币的额度
    mapping(address => mapping (address => uint)) _allowance;

    // Implement the balanceOf function
    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf[account];
    }

    // Implement the allowance function
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    // 调用者向 to 地址转账
    function transfer(address to, uint256 value) external returns (bool) {
        _balanceOf[msg.sender] -= value;
        _balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // 调用者授予代理人 spender 可以花费自己 value 数量的代币
    function approve(address spender, uint256 value) external returns (bool) {
        _allowance[msg.sender][spender] = value;
        emit  Approval(msg.sender, spender, value);
        return true;
    }

    // 调用者从被代理人 from 向 某个账户 to 转账 value
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        // 扣除调用者的可用额度
        _allowance[from][msg.sender] -= value;
        _balanceOf[from] -= value;
        _balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    // 铸币（临时方法，用于给账户设置钱）
    function mint(uint value) external {
        _balanceOf[msg.sender] = value;
    }

}