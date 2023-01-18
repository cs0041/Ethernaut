// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ForceSendEther {
    
    
    function forceSendEther(address payable _to) public payable {
       selfdestruct((_to));
    }

}