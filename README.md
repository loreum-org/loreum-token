## The LORE Token

`npm i`

`git submodule update --init --recursive`

### Foundry
```
forge build
forge test --verbosity -vvv
```

### Hardhat


```
# Compiles Solidity and Builds typechain bindings
npm run compile

# Start a local hardhat node for testing
npm run chain

# In a new Terminal, deploy contracts
npm run deploy

```

### Deployments

**Mainnet**

Address: `0x7756D245527F5f8925A537be509BF54feb2FdC99`
```
npx hardhat verify --network mainnet 0x7756D245527F5f8925A537be509BF54feb2FdC99
 0x5d45A213B2B6259F0b3c116a8907B56AB5E22095 3000000000000000000000000 100000000000000000000000000 
```

### Tokenomics

The maximum supply of LORE tokens that can be minted is `100,000,000`. Initially, `3,000,000` tokens
were minted and sent to the treasury. These tokens will be airdropped to the early founders of the project
who each supplied 1000 USDT to seed the treasury with capital to cover day to day expenses of the DAO.

There were a total of 10 initial investors in the DAO who supplied a total of 10k USDT.
Each of these 10 founders will recieve `300,000` LORE tokens as a reward for seeding the DAO treasury.

| Handle            | Address                                    |
|-------------------|--------------------------------------------|
| Bones             | `0xE6fB99a9977E92d0608a7DD74795a7EFfb455611` |
| Danny             | `0x8AF8aBedF0aD11A98Fc009057f3E21c8B4Ef225a` |
| Johnny            | `0x00A08649c1405861D024075DD41674BBcD99379C` |
| Hurricane         | `0x3b1848cAe59b946dce96e75587A7CB41dEbae598` |
| Captain Jack      | `0xB3Fc4E7Ed8f0Be134674e8209b44bB66a2D0061C` |
| Blackbeard        | `0x707bAE54593FFa8c08B21e6a600fB2b73BD2Aee4` |
| Shifty            | `0x64A5b19177F3F6AE2C546b4d63C31D60e6D03Ce4` |
| Wild Bill         | `0xf9F435283D32171D78732980d71D355903748d92` |
| Xcessive Overlord |                                            |
| JP                |                                            |

The LORE token has Mint and Burn functionality. These function will be handled directly from the 
Treasury Multisig `0x5d45A213B2B6259F0b3c116a8907B56AB5E22095` until the deployment of the Loreum Chamber.
Afterwards, it will then be entirely controlled via free-market governance. Governance proposals and
management of the DAO happens at https://dao.loreum.org