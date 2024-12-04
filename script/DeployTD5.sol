// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "src/TD5.sol";


contract DeployTokenScript is Script{
    function run() external{
        vm.startBroadcast();

        TD5_BP_ERC20 token = new TD5_BP_ERC20();
        TD5_BP_ERC223 token1 = new TD5_BP_ERC223();
        TD5_BP_ERC721 token2 = new TD5_BP_ERC721();

        console2.log("TD5_BP_ERC20 : ", address(token));
        console2.log("TD5_BP_ERC223 : ", address(token1));
        console2.log("TD5_BP_ERC721 : ", address(token2));

        vm.stopBroadcast();
    }
}