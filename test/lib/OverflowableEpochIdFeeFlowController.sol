// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../src/FeeFlowController.sol";

contract OverflowableEpochIdFeeFlowController is FeeFlowController {
    constructor(
        uint256 initPrice,
        address paymentToken_,
        address paymentReceiver_,
        uint256 epochPeriod_,
        uint256 priceMultiplier_,
        uint256 minInitPrice_
    ) FeeFlowController(initPrice, paymentToken_, paymentReceiver_, epochPeriod_, priceMultiplier_, minInitPrice_) {}

    function setEpochId(uint16 epochId) public {
        slot0.epochId = epochId;
    }
}
