// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {
    event Transfer(address from, address to, uint256 tokenId);

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownedTokenCount;

    //another way of checking it is already minted.
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address _to, uint256 _tokenId) internal virtual {
        require(_to != address(0), "Address is 0x0.");
        require(_tokenOwner[_tokenId] == address(0), "Token is already minted");

        _tokenOwner[_tokenId] = _to;
        _ownedTokenCount[_to] += 1;

        emit Transfer(address(0), _to, _tokenId);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "Address is 0x0.");
        return _ownedTokenCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "Address is 0x0.");
        return owner;
    }
}
