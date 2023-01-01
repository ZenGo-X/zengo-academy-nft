// SPDX-License-Identifier: MIT
// Author: 0xVazi
pragma solidity ^0.8.17;

import "src/ZenGoAcademyNFT.sol";
import "forge-std/Script.sol";

contract ZenGoAcademyNFTScript is Script {
    // fill the chads
    address[] chads = [address(this), address(1)];
    function run() public {
        ZenGoAcademyNFT zenGoAcademyNFT = new ZenGoAcademyNFT("ipfs://link/");
        zenGoAcademyNFT.updateEligibleChads(chads, 1);
    }
}