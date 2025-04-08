// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

contract IdeaVoting is AccessControl, Pausable {
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 private constant WITHDRAW_ROLE = keccak256("WITHDRAW_ROLE");

    uint256 public voteFee;

    event Upvote(address indexed voter, string ideaId);
    event Withdraw(address indexed user, uint256 amount);

    constructor(uint256 _voteFee){
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
        _grantRole(WITHDRAW_ROLE, _msgSender());

        voteFee = _voteFee;
    }

    function upvote(string memory ideaId) external payable whenNotPaused{
        require(msg.value == voteFee, "Insufficient fee");
        emit Upvote(_msgSender(), ideaId);
    }

    function pause() external onlyRole(ADMIN_ROLE) whenNotPaused {
        _pause();
    }
    
    function unpause() external onlyRole(ADMIN_ROLE) whenPaused {
        _unpause();
    }

    function setVoteFee(uint256 _voteFee) external onlyRole(ADMIN_ROLE) whenNotPaused {
        voteFee = _voteFee;
    }

    function withdraw() external onlyRole(WITHDRAW_ROLE) {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(_msgSender()).transfer(balance);
        emit Withdraw(_msgSender(), balance);
    }
}
