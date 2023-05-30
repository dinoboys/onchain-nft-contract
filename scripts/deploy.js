const hre = require("hardhat");

async function main() {
  const FlappyOwlTestnet = await hre.ethers.getContractFactory(
    "FlappyOwlTestnet"
  );
  const _FlappyOwlTestnetDeployed = await FlappyOwlTestnet.deploy(
    "0x181Ab45E87a0d0650DFA6298103613a2a1e3F06e"
  );

  await _FlappyOwlTestnetDeployed.deployed();
  console.log(
    "FlappyOwlTestnet Nft was deployed to:",
    _FlappyOwlTestnetDeployed.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
