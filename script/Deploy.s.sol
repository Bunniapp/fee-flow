// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.13;

import {CREATE3Script} from "./base/CREATE3Script.sol";
import {FeeFlowController} from "../src/FeeFlowController.sol";

contract DeployScript is CREATE3Script {
    constructor() CREATE3Script(vm.envString("VERSION")) {}

    function run() external returns (FeeFlowController c, bytes32 salt) {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY"));
        uint256 chainId = block.chainid;

        // Read constructor parameters from environment variables with chain-specific suffixes
        uint256 initPrice = vm.envUint(string.concat("INIT_PRICE_", vm.toString(chainId)));
        address paymentToken = vm.envAddress(string.concat("PAYMENT_TOKEN_", vm.toString(chainId)));
        address paymentReceiver = vm.envAddress(string.concat("PAYMENT_RECEIVER_", vm.toString(chainId)));
        uint256 epochPeriod = vm.envUint(string.concat("EPOCH_PERIOD_", vm.toString(chainId)));
        uint256 priceMultiplier = vm.envUint(string.concat("PRICE_MULTIPLIER_", vm.toString(chainId)));
        uint256 minInitPrice = vm.envUint(string.concat("MIN_INIT_PRICE_", vm.toString(chainId)));

        salt = getCreate3SaltFromEnv("FeeFlowController");

        vm.startBroadcast(deployerPrivateKey);

        c = FeeFlowController(
            create3.deploy(
                salt,
                bytes.concat(
                    type(FeeFlowController).creationCode,
                    abi.encode(
                        initPrice,
                        paymentToken,
                        paymentReceiver,
                        epochPeriod,
                        priceMultiplier,
                        minInitPrice
                    )
                )
            )
        );

        vm.stopBroadcast();
    }
}
