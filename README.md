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
npm run deploy:local

```

**Verifying Contracts**
https://hardhat.org/hardhat-runner/docs/guides/verifying

```
npx hardhat verify --network goerli <address> <unlock time>
```

### Deployments

**Goerli**

https://goerli.etherscan.io/address/0x481e7E976B7053bc7a95F26ec8b8688020E1F9ee

```
params [
  '0xA9bF0E34859870cF14102dC6894a7B2AC3ceDf83',
  '1000000000000000000000000',
  '10000000000000000000000000'
]

npx hardhat verify --constructor-args \ 
  ./script/hardhat/goerli.ts 0x481e7E976B7053bc7a95F26ec8b8688020E1F9ee \
  --network goerli
```