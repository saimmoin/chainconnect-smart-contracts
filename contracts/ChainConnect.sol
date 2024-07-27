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

    struct Post {
        uint256 bidDuration;
        uint256 sellValue;
        string metadata;
        uint8 buyStatus;
    }

    mapping(uint256 => Post) public posts;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _tokenOwners;

    uint256 public tokenID = 1;
    uint256 public ONE = 1 ether;
    address public admin;

    constructor(
        string memory name,
        string memory symbol,
        address admin
    ) Account(name, symbol) {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "caller is not the admin");
        _;
    }

    function changeAdmin(address _admin) external onlyAdmin {
        emit AdminChanged(admin, admin = _admin, msg.sender);
    }

    function mint(
        uint8 _buyStatus,
        uint256 _sellValue,
        uint256 _bidDuration,
        string memory _metadata
    ) external {
        bytes memory b = bytes(_metadata);
        if (b.length != 0) revert URINotEmpty();
        if (_buyStatus == 2 && _sellValue == 0) revert NotForSale();

        if (_buyStatus == 1 && _sellValue > 0) revert NoBidDuration();
        if (_buyStatus == 3 && _bidDuration > block.timestamp)
            revert NoSellValue();

        _safeMint(msg.sender, tokenID);
        _setTokenURI(tokenID, _metadata);
        _tokenOwners[tokenID] = msg.sender;
        tokenID += 1;
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
}
