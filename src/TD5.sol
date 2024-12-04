// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC223Token} from "./ERC223.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "forge-std/console.sol";

contract TD5_BP_ERC20 is ERC20 {
    constructor() ERC20("TD5_BP_ERC20", "td5_erc20") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
}

contract TD5_BP_ERC223 is ERC223Token { 
    constructor () ERC223Token("TD5_BP_ERC223", "td5_erc223", 18) {
        _mint(10000 * 10 ** 18);
    }
}

contract TD5_BP_ERC721 is ERC721 {
    uint256 public maxSupply;
    uint256 public nextTokenId;
    address public contractOwner;
    ERC20 public erc20Token; 
    ERC223Token public erc223Token;

    constructor() ERC721("TD5_BP_ERC721", "TD5NFT") {
        maxSupply = 1000;
        nextTokenId = 1; 
        contractOwner = msg.sender;
    }

    // ERC721 minting function with payment in ERC20 tokens
    function mintWithERC20(uint256 amount, address _erc20Address) public {
        erc20Token = ERC20(_erc20Address); 
        require(nextTokenId <= maxSupply, "Max supply reached");
        uint256 cost = 100 * 10 ** erc20Token.decimals();
        require(erc20Token.balanceOf(msg.sender) >= cost * amount, "Not enough ERC20 tokens");
        erc20Token.transferFrom(msg.sender, contractOwner, cost * amount);
        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, nextTokenId);
            nextTokenId++;
        }
    }

    // ERC721 minting function with payment in ERC223 tokens
    function mintWithERC223(uint256 amount, address _erc223Address) public {
        erc223Token = ERC223Token(_erc223Address);
        uint256 cost = 100 * 10 ** 18; 
        require(nextTokenId + amount - 1 <= maxSupply, "Max supply reached");
        require(erc223Token.balanceOf(msg.sender) >= cost * amount, "Not enough ERC223 tokens");
        erc223Token.transferFrom(msg.sender, contractOwner, cost * amount);
        for (uint256 i = 0; i < amount; i++) {
            _mint(msg.sender, nextTokenId);
            nextTokenId++;
        }
    }
}
