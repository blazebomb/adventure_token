// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AdventureToken is ERC20, Ownable {
    constructor(address initialOwner) ERC20("ADVT", "Adventure") Ownable(initialOwner) {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    mapping(address => uint[]) public playerInventory;
    mapping(uint => GameItem) public gameItems;
    uint public totalItemTypes = 0;

    struct GameItem {
        string name;
        uint typeId;
        uint256 price;
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function createGameItem(
        string memory name,
        uint256 price
    ) public onlyOwner {
        totalItemTypes += 1;
        uint typeId = totalItemTypes;
        gameItems[typeId] = GameItem(name, typeId, price);
    }

    function getPlayerBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function acquireGameItem(uint typeId) external {
        require(
            balanceOf(msg.sender) >= gameItems[typeId].price,
            "Insufficient funds"
        );
        approve(msg.sender, gameItems[typeId].price);
        transferFrom(msg.sender, address(this), gameItems[typeId].price);
        playerInventory[msg.sender].push(gameItems[typeId].typeId);
    }

    function transferTokens(address to, uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient funds");
        approve(msg.sender, amount);
        transferFrom(msg.sender, to, amount);
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient funds");
        approve(msg.sender, amount);
        _burn(msg.sender, amount);
    }
}
