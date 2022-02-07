// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721Test is IERC721 {
  function mintItem(address to, string memory _tokenUri) external returns(uint256 tokenId);
}