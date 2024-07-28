//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

import "./Account.sol";
import "./IChainConnect.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error NotForSale();
error NoBidDuration();
error NoSellValue();
error URINotEmpty();

contract ChainConnect is Account, IChainConnect {
    using Strings for uint256;

    /**
    1 -> For Sale
    2 -> For Bidding
    3 -> No Sell Value
     */
    struct Post {
        uint256 bidDuration;
        uint256 sellValue;
        string metadata;
        uint8 buyStatus;
    }

    struct LastBidder {
        address bidder;
        uint256 bidValue;
    }

    mapping(uint256 => Post) public posts;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _tokenOwners;
    mapping(uint256 => LastBidder) private _lastBidders;

    uint256 public tokenID = 1;
    uint256 public ONE = 1 ether;
    address public admin;

    constructor(
        string memory name,
        string memory symbol,
        address _admin
    ) Account(name, symbol) {
        admin = _admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "caller is not the admin");
        _;
    }

    function changeAdmin(address _admin) external onlyAdmin validUser {
        emit AdminChanged(admin, admin = _admin, msg.sender);
    }

    function mint(
        uint8 _buyStatus,
        uint256 _sellValue,
        uint256 _bidDuration,
        string memory _metadata
    ) external validUser {
        bytes memory b = bytes(_metadata);
        if (b.length != 0) revert URINotEmpty();
        if (_buyStatus == 2 && _sellValue == 0) revert NotForSale();

        if (_buyStatus == 1 && _sellValue > 0) revert NoBidDuration();
        if (_buyStatus == 3 && _bidDuration > block.timestamp)
            revert NoSellValue();

        _safeMint(msg.sender, tokenID);
        _setTokenURI(tokenID, _metadata);
        _tokenOwners[tokenID] = msg.sender;
        posts[tokenID] = Post(
            block.timestamp + _bidDuration,
            _sellValue,
            _metadata,
            _buyStatus
        );
        tokenID += 1;
    }

    function buyPost(uint256 _postId) external payable validUser {
        require(_postId <= tokenID && _postId > 0, "ERC721: invalid token ID");
        require(posts[_postId].buyStatus == 1, "Not for sale");
        require(posts[_postId].sellValue >= msg.value, "Insufficient funds");

        (bool sent, ) = _tokenOwners[_postId].call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        _tokenOwners[_postId] = msg.sender;
        _transfer(_tokenOwners[_postId], msg.sender, _postId);

        posts[_postId].sellValue = 0;
        posts[_postId].buyStatus = 2;
    }

    function bidPost(uint256 _postId) external payable validUser {
        require(_postId <= tokenID && _postId > 0, "ERC721: invalid token ID");
        require(posts[_postId].buyStatus == 2, "Not for bidding");
        require(_lastBidders[_postId].bidder != msg.sender, "Already bid");
        require(
            msg.value > _lastBidders[_postId].bidValue,
            "Price should be greator"
        );
        require(posts[_postId].bidDuration < block.timestamp, "Bid finished");

        if (_lastBidders[_postId].bidder != address(0)) {
            (bool sent, ) = _lastBidders[_postId].bidder.call{
                value: _lastBidders[_postId].bidValue
            }("");
            require(sent, "Failed to send Ether");
        }

        _lastBidders[_postId] = LastBidder(msg.sender, msg.value);
    }

    function changePost(
        uint256 _postId,
        uint256 _bidDuration,
        uint256 _sellValue,
        uint8 _buyStatus
    ) external validUser {
        Post storage post = posts[_postId];
        post.bidDuration = _bidDuration;
        post.sellValue = _sellValue;
        post.buyStatus = _buyStatus;
    }

    function _setTokenURI(
        uint256 _tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(
            _exists(tokenID),
            "ERC721Metadata: URI query for nonexistent token"
        );

        _tokenURIs[_tokenId] = _tokenURI;
    }

    function _exists(uint256 _tokenId) internal view virtual returns (bool) {
        require(_tokenId <= tokenID, "ERC721: invalid token ID");
        return true;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            return _tokenURI;
        }

        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }
}
