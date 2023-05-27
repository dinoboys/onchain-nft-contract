// SPDX-License-Identifier: MIT

/*********************************
*                                *
*               /)/)             *
*              ===*              *
*             (x.+)              *
*            c(")(")             *
*                                *
**********************************
*   BUNN #420              * #69 *
**********************************
*   BUY NOW               * \_/" *
**********************************/
 
/*
* ** author  : sitishinikimiti   
* ** package : @contracts/utils/ITokenDescriptor.sol
*/

pragma solidity ^0.8.17;

interface ITokenDescriptor {
    function tokenURI(uint256 tokenId, uint256 seed) external view returns (string memory);
}