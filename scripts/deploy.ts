
import { ethers } from 'hardhat'

type deployConfig = typeof localhostConfig;

const localhostConfig = {
  premintHolder:  (accounts: any) => accounts[0].address,
  PREMINT_AMOUNT:  ethers.BigNumber.from(10).pow(18).mul(3e6),
  SUPPLY_CAP: ethers.BigNumber.from(10).pow(18).mul(1e8),
}

const sepoliaConfig = {
  premintHolder:  (accounts: any) => accounts[0].address,
  PREMINT_AMOUNT:  ethers.BigNumber.from(10).pow(18).mul(3e6),
  SUPPLY_CAP: ethers.BigNumber.from(10).pow(18).mul(1e8),
}

const mainnetConfig = {
  premintHolder:  () => '0x5d45A213B2B6259F0b3c116a8907B56AB5E22095',
  PREMINT_AMOUNT:  ethers.BigNumber.from(10).pow(18).mul(3e6),
  SUPPLY_CAP: ethers.BigNumber.from(10).pow(18).mul(1e8),
}

async function main() {
  const network: String = (await ethers.provider.getNetwork()).name;
  console.log("༄ Deploying the LORE token contract to", network);
  switch (network) {
    case "unknown":
      return deploy(localhostConfig);
    case "homestead":
      return deploy(mainnetConfig);
    case "sepolia":
      return deploy(sepoliaConfig);
  }
}

async function deploy(config: deployConfig) {
  const { premintHolder, PREMINT_AMOUNT, SUPPLY_CAP } = config;

  const accounts = await ethers.getSigners();
  const Lore = await ethers.getContractFactory("LoreumToken");
  const PREMINT_HOLDER = premintHolder(accounts);

  const lore = await Lore.deploy(PREMINT_HOLDER, PREMINT_AMOUNT, SUPPLY_CAP);

  console.log(stars());
  console.log("༄ Contract Address:", "\t", lore.address);
  console.log("༄ Treasury Address:", "\t", PREMINT_HOLDER);
  console.log("༄ Treasury Balance:", "\t", ethers.utils.formatEther(PREMINT_AMOUNT.toString()), "LORE");
  console.log("༄ Max LORE Supply:", "\t", ethers.utils.formatEther(SUPPLY_CAP.toString()), "LORE");
  console.log(stars());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


const stars = () => `
˚　　　　✦　🪐　　.　　. 　 ˚　.　　　　 🌀　 . ✦　　　 　˚　　　　 .
　🚀　　.   　　˚　　 　　*　　 　　✦　　　.　　.　　　✦　˚ 　☄️ 　　　 ˚🌒　.˚　　　　✦　　　.　　. 　 ˚　.　
`