// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract FoundryToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("VirtualitoToken", "VTLT") {
        _mint(msg.sender, initialSupply);
    }

    function mintFor(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }
}
