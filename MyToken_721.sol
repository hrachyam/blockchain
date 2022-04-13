// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken_721 is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(address => uint) private minters; 

    uint constant TOKEN_PRICE = 10 ** 16 wei;

    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to, string memory uri) public payable {
        uint mintCount = minters[msg.sender];
        if (mintCount > 9) {
            require( msg.value == TOKEN_PRICE, "Token price is 0.01 ether");
        }
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _tokenIdCounter.increment();
        minters[msg.sender] += 1;
    }

    function balance() external view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function withdraw(uint _amount) external payable onlyOwner {
        require(_amount <= address(this).balance);
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to transfer");
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
