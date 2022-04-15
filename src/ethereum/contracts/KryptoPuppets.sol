// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoPuppet is ERC721Connector {
    // string public name;
    // string public symbol;

    string[] public kryptoPuppetz;
    mapping(string => bool) _kryptoPuppetzExists;

    constructor() ERC721Connector("KryptoPuppet", "KPUPZ") {}

    function mint(string memory _kryptoPuppet) public {
        // deprecated - uint id = KryptoPuppetz.push(_kryptoPuppet);

        require(!_kryptoPuppetzExists[_kryptoPuppet], "Puppet already exists.");

        kryptoPuppetz.push(_kryptoPuppet);
        uint256 _id = kryptoPuppetz.length - 1;

        _mint(msg.sender, _id);

        _kryptoPuppetzExists[_kryptoPuppet] = true;
    }

    function getKPUPList() public view returns (string[] memory) {
        return kryptoPuppetz;
    }
}
