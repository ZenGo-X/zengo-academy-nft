// SPDX-License-Identifier: MIT
// Author: 0xVazi
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "src/ERC1155SBT.sol";

contract ZenGoAcademyNFT is ERC1155SBT, Ownable {
    mapping (uint256 => mapping (address => bool)) public mintingTokenToEligibleChads;
    uint256 public currentMintingTokenId = 1;

    constructor(string memory _uri) ERC1155(_uri) {}

    function mintCertificate() public {
        require(mintingTokenToEligibleChads[currentMintingTokenId][msg.sender], "You are not eligible to mint a certificate");
        mintingTokenToEligibleChads[currentMintingTokenId][msg.sender] = false;
        _mint(msg.sender, currentMintingTokenId, 1, "");
    }

    function uri(uint256 _tokenId) public view override returns (string memory) {
        require(_tokenId != 0 && _tokenId <= currentMintingTokenId, "Token ID does not exist");
        return string(abi.encodePacked(super.uri(_tokenId), Strings.toString(_tokenId)));
    }

    /**
     * @dev Update the eligible chads addresses base for a specific tokenId.
     * @param _chadsAddresses The new eligible chads addresses.
     */
    function updateEligibleChads(address[] memory _chadsAddresses, uint256 _mintingTokenId) public onlyOwner {
        for (uint256 i; i < _chadsAddresses.length; i++) {
            mintingTokenToEligibleChads[_mintingTokenId][_chadsAddresses[i]] = true;
        }
    }

    /**
     * @dev Update the current token URI when a new token is created 
     * .in order to include the new one in the ipfs hash.
     * @param _newUri The new token URI.
     */
    function setUri(string memory _newUri) public onlyOwner {
        _setURI(_newUri);
    }

    /**
     * @dev Update the current minting token id when a new token is created.
     * @param _newTokenId The new minting token id.
     */
    function updateMintingToken(uint256 _newTokenId) public onlyOwner {
        currentMintingTokenId = _newTokenId;
    }
}
