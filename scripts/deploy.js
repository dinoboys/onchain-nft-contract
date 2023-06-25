const hre = require("hardhat");
const { verify } = require("../utils/verify");

async function main() {
  const nftFactory = await hre.ethers.getContractFactory("RobustusMusRoyaties");
  const nftContract = await nftFactory.deploy(
    "0x3d4F1B1AD0327F5b09d11F19F9DE92E54944a3D0"
  );

  await nftContract.deployed();
  console.log("RobustusMusRoyaties Nft was deployed to:", nftContract.address);
  console.log("verifying the contract ...");
  // args represent contract constructor arguments
  const args = ["0x3d4F1B1AD0327F5b09d11F19F9DE92E54944a3D0"];
  await verify(
    nftContract.address,
    args,
    "ERC-721/RobustusMusRoyaties",
    "RobustusMusRoyaties"
  );
  console.log("-----------------");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
