
import { ethers, network } from 'hardhat'
import arguments from './arguments'
async function main() {
  
  const accounts = await ethers.getSigners();
  const Lore = await ethers.getContractFactory("LoreumToken");

  const PREMINT_HOLDER = accounts[0].address;

  // 1_000_000
  const PREMINT_AMOUNT = ethers.BigNumber.from(10).pow(18).mul(1e6);
  
  // 10_000_000
  const SUPPLY_CAP = ethers.BigNumber.from(10).pow(18).mul(1e7);

  console.log('🌐 Deploying to', network.name)
  const lore = await Lore.deploy(PREMINT_HOLDER, PREMINT_AMOUNT, SUPPLY_CAP);

  console.log('🛰️  Deployed LORE Token at', lore.address)
  const PreMintHolderBal = (await lore.balanceOf(PREMINT_HOLDER)).toString()
  console.log('🧢 LORE Supply Cap', SUPPLY_CAP.toString())
  console.log('💸 Balance of Premint Holder', PREMINT_HOLDER, 'is', PreMintHolderBal);
  console.log('🚚 The total LORE supply is', (await lore.totalSupply()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});