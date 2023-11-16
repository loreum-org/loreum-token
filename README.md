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