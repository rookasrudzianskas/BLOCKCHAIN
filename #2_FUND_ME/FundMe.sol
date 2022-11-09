// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
// Get funds from user
// Withdraw funds
// Set minimum funding value in Usd

import "./PriceConverter.sol";

    error NowOwner();

// 940460
contract FundMe {
    using PriceConverter for uint256;

    // optimization with constant
    uint256 public constant MINIMUM_USD = 50 * 1e18; // 1 * 10 ** 18

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    // optimization with immutable

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // want to be able to set minimum fund amount in USD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Did not send enough!"); // 1e18 = 1 * 10 ** 18 == 1000000000000000
        // reverting, undos action before, and sends remaining gas back.
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        // brand new array, with zero objects in it
        funders = new address[](0);
        // actually withdraw the funds

        // call, if this returns data, it will be saved to dataRetured -- this is IMPORTANT AND BEST
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed.");
    }

    modifier onlyOwner {
        // with modfier first it does this, and then it does the function
        if(msg.sender != i_owner) { revert NowOwner(); }
        // require(msg.sender == i_owner, "Sender is not owner!");
        // Doing the rest of the code
        _;
    }

    // what happens if someone sends this contract without calling fund function
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}



// transfer 👇
// this refers to this contract if this errors, this will error, automatically reverts
// payable(msg.sender).transfer(address(this).balance);


// send
// with send, if it is more than 2300 in GAS. it will send a bool about success
// bool sendSuccess = payable(msg.sender).send(address(this).balance);
// if fails, we will revert
//         require(sendSuccess, "Send Failed.");
