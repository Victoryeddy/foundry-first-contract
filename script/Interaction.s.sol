// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();

        console.log("Funded fundMe with" , SEND_VALUE);
        //    The explicit conversion from address to address payable is necessary
        //  when you want to send Ether to a contract or an address. This conversion ensures that the recipient can receive Ether.
        // The address payable type is used to represent addresses that can receive Ether,
        // while the address type is used for regular addresses that cannot receive Ether.
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();

        //    The explicit conversion from address to address payable is necessary
        //  when you want to send Ether to a contract or an address. This conversion ensures that the recipient can receive Ether.
        // The address payable type is used to represent addresses that can receive Ether,
        // while the address type is used for regular addresses that cannot receive Ether.
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        
        withdrawFundMe(mostRecentlyDeployed);
        
    }
}
