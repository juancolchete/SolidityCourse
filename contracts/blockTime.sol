// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract blockTime {
    using SafeMath for uint256;
    uint256 blockDeployed;
    uint256 blockStaked;
    uint256 rewardPerBlock;
    constructor(){
        blockDeployed = block.number;
        rewardPerBlock = 1000000000000;
    }

    function blocksSpent() public view returns(uint256){
        return block.number.sub(blockDeployed);
    }

    function rewardBasedContract() public view returns(uint256){
        return block.number.sub(blockDeployed).mul(rewardPerBlock);
    }

    function stake() public{
        blockStaked = block.number;
    }
}