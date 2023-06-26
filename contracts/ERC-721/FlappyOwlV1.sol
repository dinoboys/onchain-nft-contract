// SPDX-License-Identifier: MIT
/*
 * ** author  : comunity
 * ** package : @contracts/ERC721/FlappyOwlV1.sol
 */
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "operator-filter-registry/src/DefaultOperatorFilterer.sol";
import "../utils/ITokenDescriptor.sol";

contract FlappyOwlV1 is
    ERC721A,
    DefaultOperatorFilterer,
    Ownable,
    ReentrancyGuard
{
    using Strings for uint256;
    event SeedUpdated(uint256 indexed tokenId, uint256 seed);
    mapping(uint256 => uint256) internal seeds;
    mapping(address => uint256) public mintCount;

    ITokenDescriptor public descriptor;
    uint256 public mintCost = 0.02 ether;
    uint256 public maxSupply = 21000;
    uint256 public maxMintAmountPerTx = 10;
    uint256 mintLimit = 10;
    uint256 public feeNumerator = 5;
    bool public minting = true;
    bool public updatableSeed = true;
    address public beneficiaryAddr;

    constructor(ITokenDescriptor newDescriptor) ERC721A("FlappyOwlV1", "FOV1") {
        beneficiaryAddr = owner();
        descriptor = newDescriptor;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    modifier mintRequire(uint256 _mintAmount) {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
        require(
            _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
            "Invalid mint amount!"
        );
        require(
            totalSupply() + _mintAmount <= maxSupply,
            "Will exceed maximum supply!"
        );
        _;
    }

    function mint(
        uint256 _mintAmount
    ) public payable callerIsUser mintRequire(_mintAmount) {
        require(minting, "Minting function is disabled.");
        require(msg.value >= mintCost * _mintAmount, "Insufficient funds!");
        require(
            mintCount[msg.sender] + _mintAmount <= mintLimit,
            "Public mint limit exceeded"
        );

        _mintLoop(msg.sender, _mintAmount);
        mintCount[msg.sender] += _mintAmount;
    }

    function airdrop(
        address[] memory _receiver,
        uint256 _amount
    ) external onlyOwner nonReentrant {
        uint256 totalAmount = _amount * _receiver.length;
        uint256 nextTokenId = totalSupply();
        if (nextTokenId > 0) {
            nextTokenId + 1;
        }
        for (uint256 i = 0; i < _receiver.length; i++) {
            _safeMint(_receiver[i], _amount);
        }
        for (uint256 i = 0; i < totalAmount; ) {
            seeds[nextTokenId] = generateSeed(nextTokenId);
            unchecked {
                ++nextTokenId;
                ++i;
            }
        }
    }

    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
        uint256 nextTokenId = totalSupply();
        if (nextTokenId > 0) {
            nextTokenId + 1;
        }
        unchecked {
            require(
                nextTokenId + _mintAmount <= maxSupply,
                "Exceeds max supply."
            );
        }

        for (uint256 i = 0; i < _mintAmount; ) {
            seeds[nextTokenId] = generateSeed(nextTokenId);
            unchecked {
                ++nextTokenId;
                ++i;
            }
        }
        _safeMint(_receiver, _mintAmount);
        if (address(this).balance > 0) {
            payable(beneficiaryAddr).transfer(address(this).balance);
        }
    }

    function getmintCount() public view returns (uint256) {
        return mintCount[msg.sender];
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

    function updateRoyalties(uint256 _royalties) external onlyOwner {
        feeNumerator = _royalties;
    }

    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) public view returns (address receiver, uint256 royaltyAmount) {
        tokenId;
        salePrice;
        receiver = owner();
        royaltyAmount = (feeNumerator * salePrice) / 100;
    }

    // function burn(uint256 tokenId) public {
    //     require(
    //         _isApprovedOrOwner(_msgSender(), tokenId),
    //         "Not approved to burn."
    //     );
    //     delete seeds[tokenId];
    //     _burn(tokenId);
    // }

    function getSeed(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "Token ID does not exist.");
        return seeds[tokenId];
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(_exists(tokenId), "Token ID does not exist.");
        uint256 seed = seeds[tokenId];
        return descriptor.tokenURI(tokenId, seed);
    }

    function generateSeed(uint256 tokenId) private view returns (uint256) {
        uint256 r = random(tokenId);
        uint256 headSeed = 100 * ((r % 7) + 10) + (((r >> 48) % 20) + 10);
        uint256 faceSeed = 100 *
            (((r >> 96) % 6) + 10) +
            (((r >> 96) % 20) + 10);
        uint256 bodySeed = 100 *
            (((r >> 144) % 7) + 10) +
            (((r >> 144) % 20) + 10);
        uint256 legsSeed = 100 *
            (((r >> 192) % 2) + 10) +
            (((r >> 192) % 20) + 10);
        return
            10000 *
            (10000 * (10000 * headSeed + faceSeed) + bodySeed) +
            legsSeed;
    }

    function random(
        uint256 tokenId
    ) private view returns (uint256 pseudoRandomness) {
        pseudoRandomness = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), tokenId))
        );

        return pseudoRandomness;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable override onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public payable override onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}
