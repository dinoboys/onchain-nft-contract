const hre = require("hardhat");

async function main() {
  const FODescriptorV2 = await hre.ethers.getContractFactory("FODescriptorV2");
  const _FODescriptorV2Deployed = await FODescriptorV2.deploy();

  await _FODescriptorV2Deployed.deployed();
  console.log(
    "FODescriptorV2 Nft was deployed to:",
    _FODescriptorV2Deployed.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
