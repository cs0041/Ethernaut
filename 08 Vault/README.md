# 08 Vault

```
Unlock the vault to pass the level!
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}

```

#### Remember
It's important to remember that marking a variable as private only prevents other contracts from accessing it. State variables marked as private and local variables are still publicly accessible.
 Nothing  private in the blockchain.
#### Start 


### (1) ` Unlock the vault to pass the level!`

#### We need to learn how Ethereum stores data on the blockchain.

```
Storage on Ethereum blockchain is 2²⁵⁶ slots and each slot is 32 bytes.
```

Storage is optimized to save byte space. So if sequential variables will fit in a single 32-byte slot, 

they will share the same slot, indexing from the least significant bits (from the right).

#### Example.
`uint256 = 32 bytes`    * 8bit = 1 bytes


`uint64  =   8 bytes`


`address = 32 bytes`


`bool = 1 bytes`


`bytes32 = 32 bytes`


```
  Contract A {                                           Storage in contract A
    uint256 number;                        slot 0 |         number(32 bytes)      |
    bytes32 password;    ----------------> slot 1 |         password(32 bytes)    | *  each slot is 32 bytes
    uint256 temp;                          slot 2 |         temp(32 bytes)        |
  }


  Contract B {                                                    Storage in contract B
    uint64 number;                         slot 0 | (empty slot 23) - isReal(1 bytes) - number(8 bytes)|
    bool isReal ;        ----------------> slot 1 |                owner(32 bytes)                     | *  each slot is 32 bytes
    address owner ;                        slot 2 |                password(32 bytes)                  | 
    bytes32 password;                       
  }
```
how do we do

.

.


.

Looking at the code, You can see  the contract Vault have 
```
  bool public locked;
  bytes32 private password;
```

slot sotrage will be like this

```
  Contract Vault  {                                           Storage in contract Vault 
    bool public locked;                            slot 0 |      locked(1 bytes)      |
    bytes32 private password;    ----------------> slot 1 |      password(32 bytes)    | 
  }
```


we get the location of the strorage slot of the variable `password` we are going to access, what do we do next?

Web3 library allows you to reach into contract storage via:  `web3.eth.getStorageAt(contractAddress, slotNumber)`

#### Open Developer Tools (F12)

- (1)  type `await web3.eth.getStorageAt(contract.address,1)` 

   you will see a message 
   
   `'0x412076657279207374726f6e67207365637265742070617373776f7264203a29'` this is password 
   
- (2)  type `await contract.unlock('0x412076657279207374726f6e67207365637265742070617373776f7264203a29')` and confirm transaction


Click button Submit instance and confirm transaction

# !!! we passed !!!


