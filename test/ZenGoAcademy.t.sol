// SPDX-License-Identifier: MIT
// Author: 0xVazi
pragma solidity ^0.8.17;

import "src/ZenGoAcademyNFT.sol";
import "forge-std/Test.sol";

contract ZenGoAcademyNFTTest is Test {
    ZenGoAcademyNFT zenGoAcademyNFT;
    string setUri;

    function setUp() public {
        setUri = "ipfs://link/";
        zenGoAcademyNFT = new ZenGoAcademyNFT("ipfs://link/");
    }

    function testUpdateChads() public {
        address[] memory chads = generateChads();
        zenGoAcademyNFT.updateEligibleChads(chads, 1);
        assertTrue(zenGoAcademyNFT.mintingTokenToEligibleChads(1, address(this)));
    }

    function testNotEligble() public {
        address[] memory chads = generateChads();
        zenGoAcademyNFT.updateEligibleChads(chads, 1);
        assertFalse(zenGoAcademyNFT.mintingTokenToEligibleChads(1, address(0)));
    }

    function testMultipleMints() public {
        address[] memory chads = generateChads();
        zenGoAcademyNFT.updateEligibleChads(chads, 1);
        zenGoAcademyNFT.mintCertificate();
        vm.prank(address(1));
        zenGoAcademyNFT.mintCertificate();

        vm.expectRevert("You are not eligible to mint a certificate");
        zenGoAcademyNFT.mintCertificate();
    }

    function testTokenUri() public {
        uint256 currentId = zenGoAcademyNFT.currentMintingTokenId();
        vm.expectRevert("Token ID does not exist");
        zenGoAcademyNFT.uri(currentId + 1);
        vm.expectRevert("Token ID does not exist");
        zenGoAcademyNFT.uri(0);

        string memory validUri = zenGoAcademyNFT.uri(currentId); 
        assertEq(validUri, string(abi.encodePacked(setUri, Strings.toString(currentId))));
    }

    function testBalance() public {
        address[] memory chads = generateChads();
        zenGoAcademyNFT.updateEligibleChads(chads, 1);
        zenGoAcademyNFT.mintCertificate();
        assertEq(zenGoAcademyNFT.balanceOf(address(this), 1), 1);
        assertEq(zenGoAcademyNFT.balanceOf(address(1), 1), 0);
        assertEq(zenGoAcademyNFT.balanceOf(address(1), 3), 0);
    }

    function generateChads() internal view returns (address[] memory chads) {
        chads = new address[](2);
        chads[0] = address(this);
        chads[1] = address(1);
    }

    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external pure returns (bytes4) {
        return this.onERC1155Received.selector;
    }



}