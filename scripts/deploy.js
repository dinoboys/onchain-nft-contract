const hre = require("hardhat");
const { verify } = require("../utils/verify");

async function main() {
  console.log("Deploye descriptor...");
  const descriptorFactory = await hre.ethers.getContractFactory(
    "ERC721ADescriptor"
  );
  const descriptorContract = await descriptorFactory.deploy();
  await descriptorContract.deployed();
  console.log("ERC721ADescriptor was deployed to:", descriptorContract.address);

  console.log("-----------------------");
  console.log("Deploye nfts contract ...");
  const nftFactory = await hre.ethers.getContractFactory("FlappyOwlV1");
  const nftContract = await nftFactory.deploy(descriptorContract.address);

  await nftContract.deployed();
  console.log("FlappyOwlV1 Nft was deployed to:", nftContract.address);
  console.log("-----------------------");
  // args represent contract constructor arguments
  const args = [descriptorContract.address];
  await verify(nftContract.address, args, "ERC-721/FlappyOwlV1", "FlappyOwlV1");
  console.log("-----------------------");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
