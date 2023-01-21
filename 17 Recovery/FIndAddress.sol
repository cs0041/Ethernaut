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