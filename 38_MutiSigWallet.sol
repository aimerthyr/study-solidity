// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27; 

/*
    多重签名钱包（即需要转账时，需要多个人同意才可以）
    1. 合约创建时，需要告诉合约，这个钱包的拥有者（A、B、C）是哪几个地址以及会签的人数（2）
    2. A 调用 deposit 存入 2000 wei
    2. A 提交一个转账申请（to C value 1000 wei）
    3. A 尝试调用 execute 但是会被 isMatchRequiredNum 修改器拦截 因为没有满足会签人数
    4. B 调用 approve 此时满足了会签人数 （当然如果 B 调用了 revoke 那还是需要重新在 approve）
    5. A 再次调用 execute ,此时转账成功
*/
contract MutiSigWallet {
    // 存款事件
    event Deposit(address indexed sender, uint amount);
    // 提交了一个转账申请事件
    event Submit(uint indexed txId);
    // 某个账户同意了某个转账申请
    event Approve(address indexed owner, uint indexed  txId);
    // 某个账户取消同意了某个转账申请
    event Revoke(address indexed owner, uint indexed  txId);
    // 执行转账
    event Execute(uint indexed txId);

    // 钱包的拥有者列表
    address[] public owners;
    // 是否是拥有者的映射
    mapping(address => bool) public ownerMap;
    // 需要满足几个人同意才能转账的数量限制
    uint public requireNum;

    // 转账申请的结构体
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool isExecuted;
    }
    // 转账申请列表
    Transaction[] transaction;
    // 某个申请下，钱包拥有者是否赞同的映射
    mapping (uint => mapping(address => bool)) approveMap;
    

    // 这里不能使用 calldata calldata只能用于外部调用的函数，并且修饰完之后，该变量就不可更改
    constructor(address[] memory _addr, uint _requireNum) {
        require(_addr.length > 0 , "owner is not empty");
        require(_requireNum > 0 && _requireNum <= _addr.length, "requireNum not valid");
        owners = _addr;
        for(uint i = 0; i< _addr.length; i++) {
            ownerMap[_addr[i]] = true;
        }
        requireNum = _requireNum;
    }

    // 获取某个转账申请下，目前有几个账户同意
    function getApproveNum(uint txId) private view returns (uint) {
        uint count = 0;
        for(uint i = 0; i< owners.length; i++ ) {
            if(approveMap[txId][owners[i]]) {
                count += 1;
            }
        }
        return count;
    }

    // 是否是钱包的拥有者
    modifier isOwner() {
        require(ownerMap[msg.sender], "is not owner");
        _;
    }

    // 这个申请是否存在
    modifier isExist(uint txId) {
        require(txId >= 0 && txId <= transaction.length, "txId not exist");
        _;
    }

    // 是否没有执行过
    modifier isNotExecuted(uint txId) {
        require(!transaction[txId].isExecuted, "transaction is isExecuted");
        _;
    }

    // 是否满足同意的人数
    modifier isMatchRequiredNum(uint txId) {
        require(getApproveNum(txId) >= requireNum , "not match requireNum");
        _;
    }

    // 存款
    function deposit() external payable isOwner {
        emit Deposit(msg.sender, msg.value);
    }

    // 提交转账申请
    function submit(address _to, uint _value, bytes calldata _data) external isOwner  {
        transaction.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            isExecuted: false
        }));
        // 当前申请列表的下标，作为 txId
        emit Submit(transaction.length -1);
    }

    // 调用者同意某个转账申请
    function approve(uint txId) external  isOwner isExist(txId) isNotExecuted(txId)  {
        // Transaction storage tx = transaction[txId];
        approveMap[txId][msg.sender] = true;
        emit Approve(msg.sender, txId);
    }

    // 撤销同意某个转账申请
    function revoke(uint txId) external isOwner isExist(txId) isNotExecuted(txId)  {
        approveMap[txId][msg.sender] = false;
        emit Revoke(msg.sender, txId);
    }

    // 执行转账交易
    function execute(uint txId) external isOwner isExist(txId) isNotExecuted(txId) isMatchRequiredNum(txId) {
        Transaction storage trans = transaction[txId];
        trans.isExecuted = true;
        (bool success, ) = trans.to.call{value: trans.value}("");
        require(success, "execute failed");
    }


}