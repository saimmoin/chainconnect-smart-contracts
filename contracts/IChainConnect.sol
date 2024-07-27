//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

interface IChainConnect {
    event AdminChanged(address oldAdmin, address newAdmin, address caller);
}
