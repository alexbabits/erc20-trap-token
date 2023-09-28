const hre = require("hardhat");

async function main() {
  // Set initial supply to 1 million tokens for 18 decimals
  const initialSupply = hre.ethers.parseUnits("1000000", 18);
  // Deploy the contract. 
  const MySalmonella = await hre.ethers.deployContract("MySalmonella", [initialSupply]);
  //Wait for the contract to be deployed.
  await MySalmonella.waitForDeployment();
  // Log the contract address.
  console.log(`Deployed MySalmonella.sol at address: ${MySalmonella.target}`)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
