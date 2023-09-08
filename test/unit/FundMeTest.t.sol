// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMeScript} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); //this creates a new address
    uint256 constant ETHAMOUNT = 0.1 ether;
    uint256 constant STARTING_ETHER = 10 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMeScript deployFundMe = new DeployFundMeScript();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_ETHER); //the deal cheatcode gives a particular address funds
    }

    function testMinimumDollarRateIsGreaterThanFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18); //comparing the actual value to the expected value
    }

    // me > FundMeTest > FundMe
    // the fundMe test(i_owner) is calling the fundMe
    // the msg.sender is who is calling the fundMeTest

    function testIfOwnerIsMsgsender() public {
        assertEq(fundMe.getOwner(), msg.sender);
        // address(this) refers to the current contract address
    }

    function testIfPriceVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); //this line expects the line after to fail, this is a cheatcode in foundry
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next tx will be sent by user
        fundMe.fund{value: ETHAMOUNT}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        console.log(amountFunded);
        assertEq(amountFunded, ETHAMOUNT);
    }

    function testAddsFunderToArrayOfFunders() public {
        // Everytime we run the test it resets to 0
        vm.prank(USER);
        fundMe.fund{value: ETHAMOUNT}();

        address funder = fundMe.getFunder(0);

        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: ETHAMOUNT}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Act

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        console.log(endingFundMeBalance, endingOwnerBalance);

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //    hoax combines both the function of prank and deal into one
            // if you want to generate numbers to user for addresses we use uint160
            hoax(address(i), ETHAMOUNT);
            fundMe.fund{value: ETHAMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank(); //start and stop prank means for this withdrawal use this simulated address until its stopped
        // the start and stop prank is similar to start and stop broadcast

        console.log(fundMe.getOwner().balance);
        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }

    function testWithdrawFromMultipleFundersCheaper() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //    hoax combines both the function of prank and deal into one
            // if you want to generate numbers to user for addresses we use uint160
            hoax(address(i), ETHAMOUNT);
            fundMe.fund{value: ETHAMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank(); //start and stop prank means for this withdrawal use this simulated address until its stopped
        // the start and stop prank is similar to start and stop broadcast

        console.log(fundMe.getOwner().balance);
        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }
}
