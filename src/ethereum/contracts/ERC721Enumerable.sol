// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./IERC721Enumerable.sol";

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokenIndex;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("totalSupply(bytes4)") ^
                    keccak256("tokenByIndex(bytes4)") ^
                    keccak256("tokenOfOwnerByIndex(bytes4)")
            )
        );
    }

    /// @notice Count NFTs tracked by this contract
    /// @return uint256 A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    // /// @notice Enumerate valid NFTs
    // /// @dev Throws if `_index` >= `totalSupply()`.
    // /// @param _index A counter less than `totalSupply()`
    // /// @return uint256 The token identifier for the `_index`th NFT,
    // ///  (sort order not specified)
    // function tokenByIndex(uint256 _index) external view returns (uint256) {}

    // /// @notice Enumerate NFTs assigned to an owner
    // /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    // ///  `_owner` is the zero address, representing invalid NFTs.
    // /// @param _owner An address where we are interested in NFTs owned by them
    // /// @param _index A counter less than `balanceOf(_owner)`
    // /// @return uint256 The token identifier for the `_index`th NFT assigned to `_owner`,
    // ///   (sort order not specified)
    // function tokenOfOwnerByIndex(address _owner, uint256 _index)
    //     external
    //     view
    //     returns (uint256)
    // {}

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        _addTokensToAllEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllEnumeration(uint256 tokenId) private {
        _allTokenIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        override
        returns (uint256)
    {
        require(
            index < balanceOf(owner),
            "Owner's Index is out of bound in tokenOfOwnerByIndex() function."
        );
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index)
        public
        view
        override
        returns (uint256)
    {
        require(
            index < totalSupply(),
            "Global index is out of bound in tokenByIndex() function."
        );
        return _allTokens[index];
    }
}
