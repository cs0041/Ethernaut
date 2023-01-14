# 12 Privacy

```
The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:

Understanding how storage works
Understanding how parameter parsing works
Understanding how casting works
Tips:

Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {

  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp);
  bytes32[3] private data;

  constructor(bytes32[3] memory _data) {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}

```

#### Start 


### (1) `Unlock this contract `


As we know Ethereum stores data on the blockchain from the `ethernaut 08 Vault `, 
we have a bit more to know: 

```
Structs and array data always start a new slot and occupy whole slots 
(but items inside a struct or array are packed tightly according to these rules).
```
To get through we need set `locked = false` , we need to call `function unlock(bytes16 _key) public` and pass the condition 

`require(_key == bytes16(data[2]));` So we need data (data[2]) .

let's start

.

.

.

Looking at the code, You can see  the contract Privacy have data structure  like this
```
  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp);
  bytes32[3] private data;
```

slot sotrage will be like this

```
  Contract Privacy  {                                                                                             Storage in contract Privacy 
    bool public locked = true;                                                 slot 0 |                         (empty slot 31) - locked(1 bytes)                                  |
    uint256 public ID = block.timestamp;                                       slot 1 |                                 ID(32 bytes)                                               |
    uint8 private flattening = 10;                                             slot 2 | (empty slot 28bytes) - awkwardness(2 bytes) - denomination(1 bytes) - flattening(1 bytes)  |
    uint8 private denomination = 255;                        ----------------> slot 3 |                                data[0](32 bytes)                                           | 
    uint16 private awkwardness = uint16(block.timestamp);                      slot 4 |                                data[1](32 bytes)                                           | 
    bytes32[3] private data;                                                   slot 5 |                                data[2](32 bytes)                                           |
  }
```
we get the location of the strorage slot of the variable `data[2]` we are going to access, what do we do next?

Web3 library allows you to reach into contract storage via:  `web3.eth.getStorageAt(contractAddress, slotNumber)`


#### Open Developer Tools (F12)

- (1)  type `await web3.eth.getStorageAt(contract.address,5)` 

   you will see a message 
   
   `'0x1ea794c80a7aca8f2d34ad56b2f0bdbbe5da58d7b6dd4dd16986cea9181d4615'` this is password 

   
  But you can't use this password yet because it has to be casting to bytes16 
   
- (2)  In this step we will write a bit of code on the remix to see what the password will be casting to bytes16
    ```
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract castToBytes16 {
      function cast() external pure returns (bytes16) {
          bytes32  data = 0x1ea794c80a7aca8f2d34ad56b2f0bdbbe5da58d7b6dd4dd16986cea9181d4615;
          return bytes16(data);
        }
    }
    ```

    call `function cast() external pure returns (bytes16)`  
    
    you will see a message  `0:  bytes16: 0x1ea794c80a7aca8f2d34ad56b2f0bdbb` This is the password we can use.


- (3)  type `await contract.unlock('0x1ea794c80a7aca8f2d34ad56b2f0bdbb')` and confirm transaction

Click button Submit instance and confirm 

# !!! we passed !!!

#### ***Additional things to know
when you downcast is meant you will lose data because you put bigger data to smaller storage

You can see from where we dowcast bytes32 to bytes16, 

An example from where we did this challenge


`bytes32` 0x1ea794c80a7aca8f2d34ad56b2f0bdbbe5da58d7b6dd4dd16986cea9181d4615
        
`bytes16` 0x1ea794c80a7aca8f2d34ad56b2f0bdbb

result : It will takes higher order 16 bytes and cut off the rest



