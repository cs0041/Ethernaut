# 01 Fallback


```
You will beat this level if
    1. you claim ownership of the contract
    2. you reduce its balance to 0
```
####  code
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {

  mapping(address => uint) public contributions;
  address public owner;

  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}

```

#### Start 


### (1) `you claim ownership of the contract`


You must change the address public owner variable to your address

This can be done by `receive()`  because in `receive()` have command `owner = msg.sender;`

But you must pass conditions first. `require(msg.value > 0 && contributions[msg.sender] > 0);`

#### Open Developer Tools (F12)

- (1)  Let's make it through the first condition `contributions[msg.sender] > 0` 

    You must pass a value less than `0.001ether` because  `contribute()` function `requires(msg.value < 0.001 ether);`
    
    type  `await contract.contribute({value: toWei('0.0001')})`  and confirm transaction


- (2) Next you need to call `receive()` function

  You can do this by sending a tracnsaction where msg.data contains nothing

    type `await contract.sendTransaction({value: toWei('0.0001')})` and confirm transaction

    Then check who is owner now by type  `await contract.owner()`

    
### (2) `you reduce its balance to 0`
Very Ez Now that you own it, you can do whatever you want

- (1)  type `withdraw()` and confirm transaction
  
  
  Click button Submit instance and confirm transaction

# !!! we passed !!!


