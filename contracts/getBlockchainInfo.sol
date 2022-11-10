// SPDX-License-Identifier: MIT
contract getBlockchainInfo{
    function getTimestamp() public view returns(uint256){
        return block.timestamp;
    }
    function getCurrentBlockNumber() public view returns(uint256){
        return block.number;
    }
}