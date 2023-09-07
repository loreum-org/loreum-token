
import { ethers } from 'hardhat'


async function main() {
  const network: String = (await ethers.provider.getNetwork()).name;
  console.log("Network:", "\t\t", network);
  switch (network) {
    case "unknown":
      return deployLocalhost();
    case "homestead":
      return deployLocalhost();
  }
}

async function deployLocalhost() {
  
  const accounts = await ethers.getSigners();
  const Lore = await ethers.getContractFactory("LoreumToken");

  const PREMINT_HOLDER = accounts[0].address;

  const PREMINT_AMOUNT = ethers.BigNumber.from(10).pow(18).mul(1e8);
  const SUPPLY_CAP = ethers.BigNumber.from(10).pow(18).mul(1e9);

  const lore = await Lore.deploy(PREMINT_HOLDER, PREMINT_AMOUNT, SUPPLY_CAP);

  console.log("LORE Contract:", "\t\t", lore.address);
  console.log("Supply Cap:", "\t\t", SUPPLY_CAP.toString());
  console.log("Premint Holder:", "\t", PREMINT_HOLDER);
  console.log("Premint Balance:", "\t", PREMINT_AMOUNT.toString());
  console.log("Total Supply:", "\t\t", (await lore.totalSupply()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});