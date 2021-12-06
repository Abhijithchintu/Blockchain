// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import 'https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/utils/erc165.sol';

import './mint.sol';

//this is for royalty value , which we wanted to give to artist, it has artist and his art share(royalty)
interface TotalRoyalty {
    function royaltyInfo(uint256 tokenId, uint256 value)
        external
        view
        returns (address _artist, uint256 _royaltyAmount);
}

//This contract is to add ERC2981 support to 1155 and ERC721  
abstract contract TokenRoyalties is ERC165, TotalRoyalty {

  
    struct PerArtist {   //structure for artist and his royalty share
        address artist;
        uint256 royaltyvalue;
    }

    mapping(uint256 => PerArtist) internal PerArtists; //creating a map of royalties

    //this is a function for setting Royalty (struct)
    function _setTokenRoyalty(uint256 id, address artist,uint256 share) internal {
        require(share <= 10000, ' Royalties is high ');
        PerArtists[id] = PerArtist(artist, share);
    }

    // this is override function for royaltyinfo 
    function royaltyInfo(uint256 tokenId, uint256 share)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        PerArtist memory singleartst = PerArtists[tokenId];
        return (singleartst.artist, ( singleartst.royaltyvalue * share) / 10000);
    }
}

