const hre = require("hardhat");

async function main() {
  const MusDescriptor = await hre.ethers.getContractFactory("MusDescriptor");
  const _MusDescriptorDeployed = await MusDescriptor.deploy();

  await _MusDescriptorDeployed.deployed();
  console.log(
    "MusDescriptor Nft was deployed to:",
    _MusDescriptorDeployed.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
