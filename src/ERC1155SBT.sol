// SPDX-License-Identifier: MIT
// author: 0xVazi
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

abstract contract ERC1155SBT is ERC1155 {

    error TokenIsSoulBound();

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual override {
        if (from != address(0)) {
            revert TokenIsSoulBound();
        }
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
