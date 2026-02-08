// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Umicroloan.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        Umicroloan registry = new Umicroloan();
        
        console.log("Umicroloan deployed to:", address(registry));
        
        vm.stopBroadcast();
    }
}
