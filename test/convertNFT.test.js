const { ethers, waffle, network} = require("hardhat");
const { assert } = require('chai');

describe('ConvertNFT testing', function () {
  let nftContract;
  const TOKEN_TYPE_IPFS = 0;
  const TOKEN_TYPE_TWEETS = 1;
  const TOKEN_TYPE_SCREENSHOT = 2;

  before(async function () {
    nftContract = await ethers.getContractFactory('ConvertNFT');
    nftContract = await nftContract.deploy("ConvertNFT", "CNS");
    await nftContract.deployed();
  });
  
  describe('Test NFT contract.', function () {
    it ('Should success to mint', async function() {
      const [owner] = await ethers.getSigners();  
      const tokenURI = "https://drive.google.com/file/d/1XbPbhsIj2Wnh7ihBmdciQzlt6ENEYL_T/view?usp=sharing";
      const converType = TOKEN_TYPE_SCREENSHOT;

      await nftContract.convertNFT(tokenURI, converType);
    });

    it ('Get converted NFT', async function() {
      const [owner] = await ethers.getSigners();  
      
      const myNFTs = await nftContract.getMyTokens({from: owner.address});
      console.log(myNFTs);
    });
  });
});