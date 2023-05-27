// SPDX-License-Identifier: MIT

/*********************************
*                                *
*                /)/)            *
*               ===*             *
*             [ o,O ]             *
*                                *
     (\__/)
    { x,x }
   / )  :~)
  ==""===""==
**********************************
*   BUNN #420            *   #69 *
**********************************
*   BUY NOW              * \'_/" *
**********************************/
 
/*
* ** author  : sitishinikimiti   
* ** package : @contracts/BunnOnChain.sol
*/
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../lib/ERC721Enumerable.sol";
import "../utils/ITokenDescriptor.sol";

contract BOC is ERC721Enumerable, Ownable {
    using Strings for uint256;
    event SeedUpdated(uint256 indexed tokenId, uint256 seed);
    mapping(uint256 => uint256) internal seeds;


    ITokenDescriptor public descriptor;
    uint256 public mintCost = 0.02 ether;
    uint256 public maxSupply = 10000;
    bool public minting = false;
    bool public updatableSeed = true;
    address public beneficiaryAddr;

    constructor(
        ITokenDescriptor newDescriptor
    ) ERC721("Bunn On Chain", "BUNN") {
        beneficiaryAddr = owner();
        descriptor = newDescriptor;
    }

    function mint(uint32 count) external payable {
        require(minting, "Minting function is disabled.");
        require(count <= 10, "Exceeds max per transaction.");
        require(msg.value >= mintCost * count, "Insufficient funds!");
        uint256 nextTokenId = _owners.length;
        unchecked {
            require(nextTokenId + count <= maxSupply, "Exceeds max supply.");
        }

        for (uint32 i; i < count;) {
            seeds[nextTokenId] = generateSeed(nextTokenId);
            _mint(_msgSender(), nextTokenId);
            unchecked { ++nextTokenId; ++i; }
        }
        
        if(address(this).balance > 0){
            payable(beneficiaryAddr).transfer(address(this).balance);
        }
    }

    function setMinting(bool value) external onlyOwner {
        minting = value;
    }

    function setDescriptor(ITokenDescriptor newDescriptor) external onlyOwner {
        descriptor = newDescriptor;
    }

    function updateSeed(uint256 tokenId, uint256 seed) external onlyOwner {
        require(updatableSeed, "Cannot set the seed");
        seeds[tokenId] = seed;
        emit SeedUpdated(tokenId, seed);
    }

    function disableSeedUpdate() external onlyOwner {
        updatableSeed = false;
    }

    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Not approved to burn.");
        delete seeds[tokenId];
        _burn(tokenId);
    }

    function getSeed(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "Token ID does not exist.");
        return seeds[tokenId];
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token ID does not exist.");
        uint256 seed = seeds[tokenId];
        return descriptor.tokenURI(tokenId, seed);
    }

    function totalSupply() override public view returns (uint256) {
        return _owners.length;
    }

    function generateSeed(uint256 tokenId) private view returns (uint256) {
        uint256 r = random(tokenId);
        uint256 headSeed = 100 * (r % 7 + 10) + ((r >> 48) % 20 + 10);
        uint256 faceSeed = 100 * ((r >> 96) % 6 + 10) + ((r >> 96) % 20 + 10);
        uint256 bodySeed = 100 * ((r >> 144) % 7 + 10) + ((r >> 144) % 20 + 10);
        uint256 legsSeed = 100 * ((r >> 192) % 2 + 10) + ((r >> 192) % 20 + 10);
        return 10000 * (10000 * (10000 * headSeed + faceSeed) + bodySeed) + legsSeed;
    }

    function random(uint256 tokenId) private view returns (uint256 pseudoRandomness) {
        pseudoRandomness = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), tokenId))
        );

        return pseudoRandomness;
    }
}
