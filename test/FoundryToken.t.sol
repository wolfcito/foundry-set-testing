// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Utilities} from "./utils/Utilities.sol";
import {FoundryToken} from "../src/FoundryToken.sol";

contract FoundryTokenTest is Test {
    Utilities internal utils;
    FoundryToken internal token;

    address payable internal alice;
    address payable internal bob;

    function setUp() public {
        utils = new Utilities();
        token = new FoundryToken(1000);

        // Create a user
        address payable[] memory users = utils.createUsers(2);

        // Assign the user 0 as Alice
        alice = users[0];
        vm.label(alice, "Alice");

        // Assign the user 1 as Bob
        bob = users[1];
        vm.label(bob, "Bob");

        // Transfer 100 tokens to Alice
        token.transfer(alice, 100);
    }

    function testName() public {
        assertEq(token.name(), "FoundryToken");
    }

    function testSymbol() public {
        assertEq(token.symbol(), "FTK");
    }

    function testSupply() public {
        assertEq(token.totalSupply(), 1000);
    }

    function testOnlyOwnerCanMint() public {
        // The owner can mint more tokens
        token.mintFor(address(this), 1000);
        assertEq(token.totalSupply(), 2000);

        // Alice can't mint more tokens
        vm.startPrank(alice);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        token.mintFor(alice, 1000);
    }

    function testSentAliceToBob() public {
        // Make sure alice has 100 tokens
        assertEq(token.balanceOf(alice), 100);

        // Use alice as the sender
        vm.startPrank(alice);

        // Transfer the tokens
        token.transfer(bob, 60);

        // Check that the balance of alice is 40
        assertEq(token.balanceOf(alice), 40);

        // Check that the balance of bob is 60
        assertEq(token.balanceOf(bob), 60);
    }
}
