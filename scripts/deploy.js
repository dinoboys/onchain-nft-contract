const hre = require("hardhat");
const { verify } = require("../utils/verify");

async function main() {
  console.log("Deploye descriptor...");
  const descriptorFactory = await hre.ethers.getContractFactory(
    "ERC721ADescriptor"
  );
  const descriptorContract = await descriptorFactory.deploy();
  await descriptorContract.deployed();
  console.log("ERC721ADescriptor was deployed to:", ERC721ADescriptor.address);

  const nftFactory = await hre.ethers.getContractFactory("FlappyOwlV1");
  const nftContract = await nftFactory.deploy(ERC721ADescriptor.address);

  await nftContract.deployed();
  console.log("FlappyOwlV1 Nft was deployed to:", nftContract.address);
  console.log("verifying the contract ...");
  // args represent contract constructor arguments
  const args = [ERC721ADescriptor.address];
  await verify(nftContract.address, args, "ERC-721/FlappyOwlV1", "FlappyOwlV1");
  console.log("-----------------");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
