// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMeScript} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interaction.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    
    address USER = makeAddr("user"); //this creates a new address
    uint256 constant ETHAMOUNT = 0.3 ether;
    uint256 constant STARTING_ETHER = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMeScript deploy = new DeployFundMeScript();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_ETHER); //the deal cheatcode gives a particular address funds
    }

    function testUserCanFundInteraction() public {
        FundFundMe fundFundMe = new FundFundMe();

        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withDrawFundMe = new WithdrawFundMe();
        withDrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}
