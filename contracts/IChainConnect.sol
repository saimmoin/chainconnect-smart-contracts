//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

error NotForSale();
error NoBidDuration();
error NoSellValue();
error URINotEmpty();

interface IChainConnect {
    event AdminChanged(address oldAdmin, address newAdmin, address caller);
    event PostSold(address lastBidder, uint256 bidValue, uint256 postID);
    event RewardClaimed(address user, uint256 reward);
    event PostCreated(address user, uint256 tokenID);
    event PostBought(address user, uint256 value, uint256 tokenID);
    event PostBid(address user, uint256 value, uint256 postId);
    event PostChanged(uint256 postId, uint256 bidDuration, uint256 sellValue, uint8 buyStatus);

}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function mint(address _to, uint _amount) external;
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

