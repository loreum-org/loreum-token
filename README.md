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

```
#1
npx hardhat verify --network goerli 0xDB0072e4741624cBE881579aaA6425F8a8C85F5e
 0xA9bF0E34859870cF14102dC6894a7B2AC3ceDf83 10000000000000000000000000 1000000000000000000000000000 
Generating typings for: 7 artifacts in dir: typechain-types for target: ethers-v5
Successfully generated 32 typings!
Compiled 7 Solidity files successfully
Compiling your contract excluding unrelated contracts did not produce identical bytecode.
Trying again with the full solc input used to compile and deploy it.
This means that unrelated contracts may be displayed on Etherscan...

Successfully submitted source code for contract
src/LoreumToken.sol:LoreumToken at 0xDB0072e4741624cBE881579aaA6425F8a8C85F5e
for verification on the block explorer. Waiting for verification result...

Successfully verified full build of contract LoreumToken on Etherscan.
https://goerli.etherscan.io/address/0xDB0072e4741624cBE881579aaA6425F8a8C85F5e#code

#2
npx hardhat verify --constructor-args ./script/hardhat/fixtures.ts 0x4C5a6A9871D59A71766822B99633CF332569aD95 --network goerli
Generating typings for: 7 artifacts in dir: typechain-types for target: ethers-v5
Successfully generated 32 typings!
Compiled 7 Solidity files successfully
Compiling your contract excluding unrelated contracts did not produce identical bytecode.
Trying again with the full solc input used to compile and deploy it.
This means that unrelated contracts may be displayed on Etherscan...

Successfully submitted source code for contract
src/LoreumToken.sol:LoreumToken at 0x4C5a6A9871D59A71766822B99633CF332569aD95
for verification on the block explorer. Waiting for verification result...

Successfully verified full build of contract LoreumToken on Etherscan.
https://goerli.etherscan.io/address/0x4C5a6A9871D59A71766822B99633CF332569aD95#code
```