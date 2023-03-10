# 17 Recovery

```
A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. After deploying 
the first token contract, the creator sent 0.001 ether to obtain more tokens. They have since lost the contract address.

This level will be completed if you can recover (or remove) the 0.001 ether from the lost contract address.
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Recovery {

  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken {

  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value * 10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender] - _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}

```




#### Start 


### (1) `remove 0.001 ether from the lost contract address`


We need to find the missing SimpleToken address generated by contract Recovery. 

How do we do that?

.

.

.


Here is a link on how to find it

https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed/761#761





```
The address for an Ethereum contract is deterministically computed from the address of its 

creator (sender) and how many transactions the creator has sent (nonce). 

The sender and nonce are RLP encoded and then hashed with Keccak-256.
```


```
nonce0= address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), YOUR_ADDR, bytes1(0x80))))));
nonce1= address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), YOUR_ADDR, bytes1(0x01))))));
```
We already have a contract address, but we don't know what our nonce is.

```
nonce for EOA is the number of transaction  
nonce for contract is number of contract that the contract itself has created
```

Here our nonce is contract and `contract Recovery` has already created the contract once with code


   ` new SimpleToken(_name, msg.sender, _initialSupply);`


so the nonce value is 1

Let's create a contract to find our missing address


#### This is the code I used 
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface SimpleToken   {
  function transfer(address _to, uint _amount) external;
  function destroy(address  _to) external;
}

contract FindAddress {

    function  calAddress(address _target) public pure  returns(address  nonce1){
        nonce1= address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _target, bytes1(0x01))))));
    }

    function callDestroy(address _target,address _receive)  external { 
      SimpleToken(calAddress(_target)).destroy(_receive);

    }
}
```


- ` function  calAddress(address _target) public pure  returns(address  nonce1)`

    This function  find the address that we lost

    
    input parameters   
          `_target` is address contract Recovery   
- `function callDestroy(address _target,address _receive)  external`

    This function will call  `destroy()` function in the contract `SimpleToken` to `selfdestruct()` and remove all 0.001 ether in lost contract.

    input parameters   
          `_target` is address contract Recovery   
          `_receive ` is address which you want to receive 0.001 ether


Use the remix deploy contract `FindAddress` 

Call `function callDestroy(address _target,address _receive)  external`    and confirm transaction 


Click button Submit instance and confirm transaction 

# !!! we passed !!!

I have something to say  

There's another easier way is find lost contract address in etherscan but in that way we hardly gain knowledge


