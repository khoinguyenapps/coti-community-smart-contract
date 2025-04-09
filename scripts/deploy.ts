import "@nomicfoundation/hardhat-ethers";
import { ethers } from "hardhat";

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account: ", owner.address);
  console.log("Account balance: ", (await owner.provider.getBalance(owner)).toString());

  console.log("Deploying contracts...");
  const voteFee = ethers.parseUnits("0.01", "ether");

  const deploy = async () => {
    const IdeaVoting = await ethers.getContractFactory("IdeaVoting");
    const ideaVoting = await IdeaVoting.deploy(voteFee, {
      gasLimit: 1_000_000,
    });

    console.table({
      ideaVoting: await ideaVoting.getAddress(),
    });
  };

  await deploy();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
