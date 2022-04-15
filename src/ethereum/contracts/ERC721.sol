// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./IERC721.sol";

contract ERC721 is ERC165, IERC721 {
    // event Transfer(address from, address to, uint256 tokenId);

    // event Approve(
    //     address indexed owner,
    //     address indexed approved,
    //     uint256 indexed tokenId
    // );

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownedTokenCount;
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("tranferFrom(bytes4)")
            )
        );
    }

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
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "Address is 0x0.");
        return _ownedTokenCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "Address is 0x0.");
        return owner;
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _tokenOwner[_tokenId] == _from,
            "The address is not the owner of token. Can not trasnfer!"
        );
        require(_to != address(0), "Receiver's address is 0x0.");

        _tokenOwner[_tokenId] = _to;
        _ownedTokenCount[_from] -= 1;
        _ownedTokenCount[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(isApprovedOrOwner(_from, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "Approval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of token"
        );
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address _spender, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        //this thing only does owner and not approval
        //for approval we can refer to openZepplin.
        require(_exists(_tokenId), "token does not exists.");
        address owner = ownerOf(_tokenId);

        return owner == _spender;
    }
}
