// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Aula03{
    uint256 stateVariable;

    function pureSample(uint256 localVariable) pure {
        return stateVariable;
    }
    function viewSample(uint256 localVariable) view{
        return stateVariable;
    }
}