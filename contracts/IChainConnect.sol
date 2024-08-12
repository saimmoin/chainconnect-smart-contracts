//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

interface IChainConnect {
    event AdminChanged(address oldAdmin, address newAdmin, address caller);
    event PostSold(address lastBidder, uint256 bidValue, uint256 postID);
    event ClaimReward(address user, uint256 reward);
}
