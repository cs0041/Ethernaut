# 02 Fallout


```
Claim ownership of the contract below to complete this level.

  Things that might help

Solidity Remix IDE
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'openzeppelin-contracts-06/math/SafeMath.sol';

contract Fallout {
  
  using SafeMath for uint256;
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
	        require(
	            msg.sender == owner,
	            "caller is not the owner"
	        );
	        _;
	    }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender].add(msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    msg.sender.transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}

```

#### Start 


### (1) `Claim ownership of the contract below to complete this level.`

The instruction to claim ownership is at constructor `Fal1out()` `owner = msg.sender;`

how do we do

.

.

.


.

.


In solidity 0.6.0 it is possible to declare a constructor with the same function name as the contact name

But if you look closely, this contract is called `Fallout` but the function that says constructor is called `Fal1out` doesn't match

Makes `Fal1out` a normal function, not a constructor.


#### Open Developer Tools (F12)

- (1)  type `await contract.Fal1out()` and confirm transaction

    Then check who is owner now by type  `await contract.owner()`

    Click button Submit instance and confirm transaction

# !!! we passed !!!


