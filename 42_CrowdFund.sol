// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

// 众筹合约
contract CrowdFund {
    // 众筹中使用的哪个代币合约
    IERC20 tokenContract;

    // 一个众筹的结构
    struct Crowd {
        // 发起者
        address creator;
        // 目标金额
        uint target;
        // 当前金额
        uint current;
        // 开始时间
        uint32 startTime;
        // 结束时间
        uint32 endTime;
        // 是否已经完成
        bool completed;
    }
    // 众筹列表
    Crowd[] public crowdList;
    // 每个众筹下每个账户中的代币总数
    mapping (uint => mapping (address => uint)) crowdMap;

    constructor(address _tokenContract){
        tokenContract = IERC20(_tokenContract);
    }

    // 临时调试，获取当前调用的时间
    function currentTime() external view returns(uint) {
        return block.timestamp;
    }
    
    // 发起一个众筹
    function launch(uint _target, uint32 _startTime, uint32 _endTime)  external  {
        require(_startTime > block.timestamp, "startTime is illegal");
        require(_endTime > _startTime + 1 days , "endTime must be one day later than startTime");
        Crowd memory item = Crowd({
            creator: msg.sender,
            target: _target,
            current: 0,
            startTime: _startTime,
            endTime: _endTime,
            completed: false
        });
        crowdList.push(item);
    }

    // 参与一个众筹
    function pledge(uint id, uint value) external  {
        require(id <= crowdList.length - 1, "crowd is not exist");
        Crowd storage item = crowdList[id];
        require(block.timestamp >= item.startTime, "crowd is not start");
        require(block.timestamp <= item.endTime, "crowd is end");
        item.current += value;
        crowdMap[id][msg.sender] += value;
        // 将发起者的代币，转入众筹合约中
        tokenContract.transferFrom(msg.sender, address(this), value);
    }

    // 取消一个众筹
    function unpledge(uint id) external {
        require(id <= crowdList.length - 1, "crowd is not exist");
        Crowd storage item = crowdList[id];
        require(block.timestamp < item.startTime, "crowd is start");
        uint value = crowdMap[id][msg.sender];
        item.current -= value;
        crowdMap[id][msg.sender] = 0;
        tokenContract.transfer(msg.sender, value);
    }

    // 时间结束后，拿出筹款
    function claim(uint id) external  {
        Crowd storage item = crowdList[id];
        require(block.timestamp > item.endTime, "crowd is not end");
        require(item.current >= item.target, "current is not match target");
        require(msg.sender == item.creator, "is not your crowd");
        require(!item.completed, "crowd is completed");
        item.completed = true;
        tokenContract.transfer(msg.sender, item.current);
    }

    // 时间结束后，没有达到的话，则可以退款
    function refund(uint id) external {
        Crowd storage item = crowdList[id];
        require(block.timestamp > item.endTime, "crowd is not end");
        require(item.current < item.target, "current is  match target");
        uint fund = crowdMap[id][msg.sender];
        require(fund > 0, "no refund");
        crowdMap[id][msg.sender] = 0;
        tokenContract.transfer(msg.sender, fund);

    }
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20 {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Solidity by Example";
    string public symbol = "SOLBYEX";
    uint8 public decimals = 18;

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
