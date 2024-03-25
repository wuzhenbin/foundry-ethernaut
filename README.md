```shell
forge test --match-path ./test/Fallback.t.sol
forge test --match-path ./test/Fallout.t.sol
forge test --match-path ./test/CoinFlip.t.sol
forge test --match-path ./test/Telephone.t.sol
forge test --match-path ./test/Token.t.sol
forge test --match-path ./test/Delegation.t.sol
forge test --match-path ./test/Force.t.sol
forge test --match-path ./test/Vault.t.sol
forge test --match-path ./test/King.t.sol
forge test --match-path ./test/Reentrancy.t.sol
forge test --match-path ./test/Elevator.t.sol
forge test --match-path ./test/Privacy.t.sol
forge test --match-path ./test/GatekeeperOne.t.sol
forge test --match-path ./test/GatekeeperTwo.t.sol
forge test --match-path ./test/NaughtCoin.t.sol
forge test --match-path ./test/Preservation.t.sol
forge test --match-path ./test/Recovery.t.sol
forge test --match-path ./test/MagicNumber.t.sol
forge test --match-path ./test/AlienCodex.t.sol
forge test --match-path ./test/Denial.t.sol
forge test --match-path ./test/Shop.t.sol
forge test --match-path ./test/Dex.t.sol


forge install OpenZeppelin/openzeppelin-contracts@v3.4.2 --no-commit (solidity 0.6)
forge install OpenZeppelin/openzeppelin-contracts@v4.8.2 --no-commit (solidity 0.6)
```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
