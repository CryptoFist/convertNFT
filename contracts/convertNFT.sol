// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract ConvertNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    enum ConvertType {IPFS, TWEETS, SCREENSHOT }

    struct RenderToken{
        uint256 id;
        string uri;
		address owner;
    }

    Counters.Counter private tokenId;
    mapping(uint256 => string) private tokenURIs;
    mapping(uint256 => uint8) private convertTypes;
    mapping(address => uint256) private tokenAmount;

    event converted(
        string hash, 
        uint256 id,
        uint8 converType
    );

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
    }

    function getMintedAmount() public view returns(uint256) {
        return tokenId.current();
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI) internal {
        tokenURIs[_tokenId] = _tokenURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns(string memory) {
	  require(_exists(_tokenId));
	  string memory _tokenURI = tokenURIs[_tokenId];
	  return _tokenURI;
    }

    function getMyTokens() public view returns(RenderToken[] memory) {
        uint256 latestId = tokenId.current();  
		uint256 counter = 0;
		uint256 i;
        uint256 myCount = tokenAmount[_msgSender()];

	    RenderToken[] memory result = new RenderToken[](myCount); // latest id is the maximum size of the current tokens.

        for(i = 0; i < latestId; i++) {
        if(_exists(i) && ownerOf(i) == msg.sender) {
            string memory uri = tokenURI(i);
            result[counter ++] = RenderToken(i, uri, msg.sender);
        }
	  }

	  return result;
  }

    function convertNFT(string memory _tokenURI, uint8 _convertType) public {
        uint256 newId = tokenId.current();
        string memory uri = string(abi.encodePacked(_tokenURI));

        _mint(msg.sender, newId);
        setTokenURI(newId, uri);
        tokenId.increment();
        convertTypes[newId] = _convertType;
        tokenAmount[_msgSender()] = tokenAmount[_msgSender()].add(1);

        emit converted(uri, newId, _convertType);
    }
}