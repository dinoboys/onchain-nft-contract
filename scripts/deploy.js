const hre = require("hardhat");

async function main() {
  const BOC = await hre.ethers.getContractFactory("BOC");
  const _BOCDeployed = await BOC.deploy(
    "0x2a8350BCE39C218423886F552425367065791cBd"
  );

  await _BOCDeployed.deployed();
  console.log("BOC Nft was deployed to:", _BOCDeployed.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
