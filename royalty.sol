pragma solidity ^0.8.6;

import 'https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/utils/erc165.sol';

import './IERC2981Royalties.sol';

//This contract is to add ERC2981 support to 1155 and ERC721  
abstract contract ERC2981PerTokenRoyalties is ERC165, IERC2981Royalties {

  
    struct Royalty {
        address artist;
        uint256 value;
    }

    mapping(uint256 => Royalty) internal royalties; //creating a map of royalties

    //this is a function for setting Royalty (struct)
    function _setTokenRoyalty(uint256 id, address artist,uint256 value) internal {
        require(value <= 10000, 'ERC2981Royalties is high ');
        royalties[id] = Royalty(artist, value);
    }

    // this is override function for royaltyinfo 
    function royaltyInfo(uint256 tokenId, uint256 value)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        Royalty memory royalty = _royalties[tokenId];
        return (royalty.recipient, (value * royalty.value) / 10000);
    }
}

//this is for royalty value , which we wanted to give to artist, it has artist and his art share(royalty)
interface IERC2981Royalties {
    function royaltyInfo(uint256 tokenId, uint256 value)
        external
        view
        returns (address _artist, uint256 _royaltyAmount);
}
