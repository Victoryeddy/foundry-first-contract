// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMeScript is Script {
    function run() external returns (FundMe) {
        // Any thing before startBroadcast is not a real tx
        // only things after the startBroadcast
        // so we are not using gas by calling stuff before startBroadcast
        HelperConfig helperConfig = new HelperConfig();

        address ethUSDPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUSDPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
