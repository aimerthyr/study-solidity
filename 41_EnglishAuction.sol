// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;


contract EnglishAuction {
    IERC721 immutable nft;
    uint immutable nftId;
    // 拍卖品的拥有者
    address payable  public  seller;
    // 最高拍卖人
    address payable public highestBidder;
    // 最高拍卖价
    uint public highestBid;
    // 拍卖人出价的集合
    mapping(address => uint) bidMap;
    // 拍卖是否开始
    bool public isStart;
    // 拍卖是否结束
    bool public isEnd;

    constructor(address _nft, uint _nftId, uint _startPrice) payable  {
        nft = IERC721(_nft);
        nftId = _nftId;
        highestBid = _startPrice;
        seller = payable(msg.sender);
    }

    function start() external  {
        require(!isStart, "auction already start");
        isStart = true;
         // 将 nftId 存入合约
        nft.transferFrom(seller, address(this), nftId);
    }

    function bid() payable  external {
        require(isStart, "auction is not start");
        require(!isEnd, "auction is end");
        require(msg.value > highestBid , "bid is too low");
        // 记录最高出价
        highestBid = msg.value;
        // 记录最高出价人
        highestBidder = payable(msg.sender);
        // 累计拍卖者的出价（最后可以退还）
        bidMap[msg.sender] += msg.value;
    }

    function end() external  {
        require(isStart, "auction is not start");
        require(!isEnd, "auction already ended");
        isEnd = true;
        // 说明没人拍卖
        if(highestBidder == address(0)) {
            // 则需要把合约中的物品归还给原来的人
            nft.transferFrom(address(this), seller, nftId);
        } else {
            // 将合约中的拍卖品转给最后拍中的人
            nft.transferFrom(address(this), highestBidder, nftId);
            // 将拍卖的代币转给原来的拥有者
            seller.transfer(highestBid);
        }
    }

    // 提现（拍卖最后结束，没有拍中的可以取回钱）
    function withDraw() external {
        require(isEnd, "auction is not end");
        uint refund;
        // 非拍中的人，直接取回之前在合约中的余额
        if(highestBidder != msg.sender) {
            refund = bidMap[msg.sender];
        } else {
            // 出价最高的人，因为之前可能多次出价，所以需要拿累计的出价减掉最后的成交价，得到需要退还的钱
            refund = bidMap[highestBidder] - highestBid;
        }

        require(refund > 0, "no funds to withdraw");
        bidMap[msg.sender] = 0; // 防止重入攻击
        // 将余额退还给竞拍的人
        payable(msg.sender).transfer(refund);

    }
}





interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    using Address for address;

    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(
        address indexed owner,
        address indexed approved,
        uint indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // Mapping from token ID to owner address
    mapping(uint => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint) private _balances;

    // Mapping from token ID to approved address
    mapping(uint => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    function supportsInterface(bytes4 interfaceId)
        external
        pure
        override
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function balanceOf(address owner) external view override returns (uint) {
        require(owner != address(0), "owner = zero address");
        return _balances[owner];
    }

    function ownerOf(uint tokenId) public view override returns (address owner) {
        owner = _owners[tokenId];
        require(owner != address(0), "token doesn't exist");
    }

    function isApprovedForAll(address owner, address operator)
        external
        view
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    function setApprovalForAll(address operator, bool approved) external override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint tokenId) external view override returns (address) {
        require(_owners[tokenId] != address(0), "token doesn't exist");
        return _tokenApprovals[tokenId];
    }

    function _approve(
        address owner,
        address to,
        uint tokenId
    ) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function approve(address to, uint tokenId) external override {
        address owner = _owners[tokenId];
        require(
            msg.sender == owner || _operatorApprovals[owner][msg.sender],
            "not owner nor approved for all"
        );
        _approve(owner, to, tokenId);
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint tokenId
    ) private view returns (bool) {
        return (spender == owner ||
            _tokenApprovals[tokenId] == spender ||
            _operatorApprovals[owner][spender]);
    }

    function _transfer(
        address owner,
        address from,
        address to,
        uint tokenId
    ) private {
        require(from == owner, "not owner");
        require(to != address(0), "transfer to the zero address");

        _approve(owner, address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        address owner = ownerOf(tokenId);
        require(
            _isApprovedOrOwner(owner, msg.sender, tokenId),
            "not owner nor approved"
        );
        _transfer(owner, from, to, tokenId);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            return
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                ) == IERC721Receiver.onERC721Received.selector;
        } else {
            return true;
        }
    }

    function _safeTransfer(
        address owner,
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) private {
        _transfer(owner, from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "not ERC721Receiver");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes memory _data
    ) public override {
        address owner = ownerOf(tokenId);
        require(
            _isApprovedOrOwner(owner, msg.sender, tokenId),
            "not owner nor approved"
        );
        _safeTransfer(owner, from, to, tokenId, _data);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function mint(address to, uint tokenId) external {
        require(to != address(0), "mint to zero address");
        require(_owners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    function burn(uint tokenId) external {
        address owner = ownerOf(tokenId);

        _approve(owner, address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}