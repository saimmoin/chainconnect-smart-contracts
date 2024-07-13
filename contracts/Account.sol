//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.26;

error InvalidAccount(address userAddress, string username);
error InvalidUsername(string username);

contract Account {
    struct Accounts {
        string username;
        string displayName;
        string imageHash;
        string bio;
    }

    mapping(address => Accounts) public accounts;
    mapping(string => bool) public usernameExists;

    event AccountCreated(
        string username,
        string displayName,
        string imageHash,
        string bio
    );
    event AccountUpdated(
        string username,
        string displayName,
        string imageHash,
        string bio
    );

    function create(
        string memory username,
        string memory displayName,
        string memory imageHash,
        string memory bio
    ) public {
        address msgSender = msg.sender;
        Accounts storage user = accounts[msgSender];

        if (
            (keccak256(abi.encodePacked((user.username))) !=
                keccak256(abi.encodePacked(("")))) ||
            usernameExists[user.username]
        ) revert InvalidAccount(msgSender, user.username);

        if (validateName(user.username)) revert InvalidUsername(user.username);

        usernameExists[username] = true;

        user.username = username;
        user.bio = bio;
        user.displayName = displayName;
        user.imageHash = imageHash;

        emit AccountCreated(username, displayName, imageHash, bio);
    }

    function update(
        string memory username,
        string memory displayName,
        string memory imageHash,
        string memory bio
    ) public {
        address msgSender = msg.sender;
        Accounts storage user = accounts[msgSender];

        if (
            (keccak256(abi.encodePacked((user.username))) ==
                keccak256(abi.encodePacked(("")))) || usernameExists[username]
        ) revert InvalidAccount(msgSender, username);

        if (validateName(user.username)) revert InvalidUsername(user.username);

        usernameExists[username] = true;
        usernameExists[user.username] = false;

        user.username = username;
        user.bio = bio;
        user.displayName = displayName;
        user.imageHash = imageHash;

        emit AccountUpdated(username, displayName, imageHash, bio);
    }

    function getAccount(
        address userAddress
    ) public view returns (Accounts memory) {
        return accounts[userAddress];
    }

    function validateName(string memory str) public pure returns (bool) {
        bytes memory b = bytes(str);
        if (b.length < 1) return false;
        if (b.length > 25) return false; // Cannot be longer than 25 characters

        for (uint256 i; i < b.length; i++) {
            bytes1 char = b[i];

            if (
                !(char >= 0x30 && char <= 0x39) && //9-0
                !(char >= 0x41 && char <= 0x5A) && //A-Z
                !(char >= 0x61 && char <= 0x7A) //a-z
            ) return false;
        }

        return true;
    }
}
