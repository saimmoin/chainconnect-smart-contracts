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
            !(compareUsername(user.username, "")) ||
            usernameExists[user.username] ||
            validateName(user.username)
        ) revert InvalidAccount(msgSender, user.username);

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
            (compareUsername(user.username, "")) ||
            usernameExists[username] ||
            validateName(user.username)
        ) revert InvalidAccount(msgSender, username);

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

    function compareUsername(
        string memory a,
        string memory b
    ) public pure returns (bool) {
        return
            keccak256(abi.encodePacked((toLower(a)))) ==
            keccak256(abi.encodePacked((toLower(b))));
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

    function toLower(string memory str) public pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint256 i = 0; i < bStr.length; i++) {
            // Uppercase character
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
}
