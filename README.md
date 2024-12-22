# LORE Token

LORE is an ERC20 token with a fixed maximum supply, designed to be used within the Loreum ecosystem. This README provides an overview of the LORE token contract and its associated components.

## Contract Overview

### LORE.sol

The `LORE` contract is an ERC20 token with additional functionality provided by the ERC20Permit extension. The contract includes the following key features:

- **Maximum Supply**: The maximum number of tokens that can ever be minted is defined at deployment and stored in the `maxSupply` state variable.
- **Constructor**: The constructor mints the initial supply of tokens to the specified owner address and sets the maximum supply.

#### Constructor Parameters

- `_maxSupply`: The maximum supply that this token can ever reach.
- `_owner`: The initial owner of the contract who receives the minted tokens.

### Constants.sol

The `Constants` library defines several constant values used throughout the LORE token ecosystem:

- `SYMBOL`: The symbol of the token ("LORE").
- `NAME`: The name of the token ("Loreum").
- `MAX_SUPPLY`: The maximum supply of the token (100,000,000 LORE).

### Actors.sol

The `Actors` library defines several constant addresses used for different deployment environments:

- `BaseActors.OWNER`: The owner address for the base deployment.
- `SepoliaActors.OWNER`: The owner address for the Sepolia testnet deployment.
- `TestActors.OWNER`: The owner address for testing purposes.

### DeployLORE.sol

The `DeployLORE` contract is a deployment script that initializes the LORE token contract with the appropriate owner address based on the current blockchain network:

- If the network is the base network (chain ID 8453), the owner is set to `BaseActors.OWNER`.
- If the network is the Sepolia testnet (chain ID 11155111), the owner is set to `SepoliaActors.OWNER`.
- For all other networks, the owner is set to `TestActors.OWNER`.

### LoreumToken.t.sol

The `LoreumTokenTests` contract contains unit tests for the LORE token contract, verifying its initialization and basic properties:

- `test_LoreumToken_init`: Tests the initial state of the LORE token contract, including the maximum supply, total supply, owner's balance, symbol, and name.

### LoreTestCycle.t.sol

The `LoreumLifecycleTest` contract contains additional tests for the LORE token contract, including:

- `test_Basic`: Tests the basic properties of the LORE token contract.
- `test_TotalSupplyEqualToAllBalance`: Tests that the total supply equals the sum of all individual balances before and after a token transfer.
- `test_TokenTransferSuccess`: Tests the successful transfer of tokens from the owner to another address.
- `test_TokenTransferFail`: Tests the failure case of token transfer when the transfer amount exceeds the owner's balance.
- `test_transferFrom`: Tests the `transferFrom` method, verifying that an approved address can transfer tokens on behalf of the owner.

## Usage

To deploy and interact with the LORE token contract, follow these steps:

1. Deploy the `LORE` contract using the `DeployLORE` script.
2. Use the deployed contract's methods to transfer tokens, approve allowances, and check balances.

## License

The LORE token contract and associated components are licensed under the MIT License and GPL-3.0-only License.
