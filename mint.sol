pragma solidity 0.8.6;

import "https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/tokens/nf-token-enumerable.sol";
import "https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/ownership/ownable.sol";

import './ERC2981PerTokenRoyalties.sol';


contract digitalToken is NFTokenEnumerable, NFTokenMetadata, Ownable, ERC2981PerTokenRoyalties{

    constructor(string memory _nftname,string memory _nftSymbol){
      nftName = _name;
      nftSymbol = _symbol;
    }


   //This function is to mint a NFT
   //_owner is adress of owner of nft, _tokenId is of NFT, _uri is RFC 3986 
  function mint( address owner, uint256 tokenId, string calldata _uri, address artist, uint256 artistShare) external onlyOwner
  {
    super._mint(owner, tokenId);
    super._setTokenUri(tokenId, _uri);
    
    if (artistShare > 0) {
        _setTokenRoyalty(tokenId, artist, artistShare);
    }
    
  }

 
   //this function is to remove nft totally
  function burn( uint256 tokenId) external onlyOwner{
    super._burn(tokenId);
  }

  //this function is to set uri to a nft
  function setTokenUriX(uint256 tokenId, string calldata _uri) external onlyOwner{
    super._setTokenUri(tokenId, _uri);
  }

   //this is a internal function for user to implement properly for nft for mint function. (function overriding)
  function _mint(address owner, uint256 tokenId) internal
    override(NFToken, NFTokenEnumerable)
    virtual
  {
    NFTokenEnumerable._mint(owner, tokenId);
  }


   //This is override function for burn. This can remint burned nft
  function _burn( uint256 tokenId)
    internal
    override(NFTokenMetadata, NFTokenEnumerable)
    virtual
  {
    NFTokenEnumerable._burn(tokenId);
    if (bytes(idToUri[tokenId]).length != 0)
    {
      delete idToUri[tokenId];
    }
  }

   //this is a override function to remove NFT Token
  function _removeNFToken(address from, uint256 tokenId )
    internal
    override(NFToken, NFTokenEnumerable)
  {
    NFTokenEnumerable._removeNFToken(from, tokenId);
  }


   //this a override function to add nft token to a adress
  function _addNFToken(address owner, uint256 tokenId)
    internal
    override(NFToken, NFTokenEnumerable)
  {
    NFTokenEnumerable._addNFToken(owner, tokenId);
  }


   //this is a override function which will give nft count of a person
  function _getOwnerNFTCount(address owner)
    internal
    override(NFToken, NFTokenEnumerable)
    view
    returns (uint256)
  {
    return NFTokenEnumerable._getOwnerNFTCount(owner);
  }

}
