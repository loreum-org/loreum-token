
import { ethers, network } from 'hardhat'

async function main() {
  
  const accounts = await ethers.getSigners();
  const Lore = await ethers.getContractFactory("LoreumToken");

  const PREMINT_HOLDER = accounts[0].address;

  console.log(PREMINT_HOLDER)
  const PREMINT_AMOUNT = ethers.BigNumber.from(10).pow(18).mul(1e7);
  const SUPPLY_CAP = ethers.BigNumber.from(10).pow(18).mul(1e9);

  console.log('🌐 Deploying to', network.name)
  const lore = await Lore.deploy(PREMINT_HOLDER, PREMINT_AMOUNT, SUPPLY_CAP);

  console.log('🛰️  Deployed LORE Token at', lore.address)
  const PreMintHolderBal = (await lore.balanceOf(PREMINT_HOLDER)).toString()
  console.log('🧢 LORE Supply Cap', SUPPLY_CAP)
  console.log('💸 Balance of Premint Holder', PREMINT_HOLDER, 'is', PreMintHolderBal);
  console.log('🚚 The total LORE supply is', (await lore.totalSupply()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});