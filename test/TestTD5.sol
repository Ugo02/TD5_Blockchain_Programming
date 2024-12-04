// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TD5.sol"; // Path to your source file

contract TD5Test is Test {
    TD5_BP_ERC20 erc20;
    TD5_BP_ERC721 erc721;
    TD5_BP_ERC223 erc223;

    address user = address(0x1234);

    function setUp() public {
        // Deploy the contracts
        erc20 = new TD5_BP_ERC20();
        erc721 = new TD5_BP_ERC721();
        erc223 = new TD5_BP_ERC223();

        // Assign a reasonable amount of ERC20 tokens to the user
        vm.prank(address(this)); // Execute the call on behalf of the deployer
        erc20.transfer(user, 1000 * 10 ** erc20.decimals());
        erc223.transfer(user, 1000 * 10 ** 18);
    }

    function testMintWithERC20() public {
        // Approve the ERC721 contract to spend user's ERC20 tokens
        vm.startPrank(user); // Simulate the call being made by 'user'
        erc20.approve(address(erc721), 100 * 10 ** erc20.decimals());
        // Initial balance of the deployer
        uint256 initialDeployerBalance = erc20.balanceOf(address(this));
        // Mint an NFT
        erc721.mintWithERC20(1, address(erc20));
        // Verify that tokenId 1 belongs to 'user'
        assertEq(erc721.ownerOf(1), user);
        // Verify that ERC20 tokens have been deducted
        assertEq(erc20.balanceOf(user), 900 * 10 ** erc20.decimals());
        // Verify that ERC20 tokens have been transferred to the contract or deployer
        assertEq(erc20.balanceOf(address(this)), initialDeployerBalance + 100 * 10 ** erc20.decimals());
        // Verify that the next token ID will be 2
        assertEq(erc721.nextTokenId(), 2);
        vm.stopPrank();
    }

    function testMintWithERC223() public {
        // Initial balance of the deployer (owner of the ERC721 contract)
        uint256 initialDeployerBalance = erc223.balanceOf(address(this));
        // Simulate the user making the mint call
        vm.startPrank(user);
        // Call the mintWithERC223 function
        erc721.mintWithERC223(1, address(erc223));
        // Verify that tokenId 1 belongs to 'user'
        assertEq(erc721.ownerOf(1), user);
        // Verify that ERC223 tokens have been deducted from the user
        assertEq(erc223.balanceOf(user), 900 * 10 ** 18);
        // Verify that ERC223 tokens have been transferred to the deployer
        assertEq(erc223.balanceOf(address(this)), initialDeployerBalance + 100 * 10 ** 18);
        // Verify that the next token ID is correctly updated
        assertEq(erc721.nextTokenId(), 2);
        vm.stopPrank();
    }
}
