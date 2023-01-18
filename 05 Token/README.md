# 05 Token

```
The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

  Things that might help:

What is an odometer?
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}


```

#### Start 


### (1) `get  additional tokens`

The hint he tells us about using Overflows




Looking at the code, You can see  the contract uses solidty version 0.6.0 and doesn't use safemath, 
which can cause overflows and underflows

We will use overflows and underflows to attack contract to increase our tokens

how do we do

.

.

.

Try looking for code that uses the + - operation.

.

.

.

You can see that the function `transfer(address _to, uint _value)` uses the + - operation. 

We will attack from 
```
require(balances[msg.sender] - _value >= 0);
balances[msg.sender] -= _value;

```

Let's start with token balances. We have 20. If we want to cause underflow, we need to bring our balances to negative number and underflow will set our token balances to  maximum values of `uint256`. 


We have to pass the variable through the function `transfer(address _to, uint _value)` `_value = 21`  


`balances[msg.sender] - _value >= 0` and `balances[msg.sender] -= _value;` it will be 20 - 21 and cause underflow and will automatically set our balances to the maximum value `uint256`. 

#### Open Developer Tools (F12)

- (1)  type `await contract.transfer('***address anyone***',21)` and confirm transaction

    Then check our token balances type  
    ```
    let t = await contract.balanceOf('***our address***')
    t.toString()
    ```

   you will see a message 
   
   `'115792089237316195423570985008687907853269984665640564039457584007913129639935'` this is maximum values of `uint256`






Click button Submit instance and confirm transaction

# !!! we passed !!!


