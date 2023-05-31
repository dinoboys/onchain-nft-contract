const hre = require("hardhat");

async function main() {
  const RobustusMus = await hre.ethers.getContractFactory("RobustusMus");
  const _RobustusMusDeployed = await RobustusMus.deploy(
    "0x3d4F1B1AD0327F5b09d11F19F9DE92E54944a3D0"
  );

  await _RobustusMusDeployed.deployed();
  console.log("RobustusMus Nft was deployed to:", _RobustusMusDeployed.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
