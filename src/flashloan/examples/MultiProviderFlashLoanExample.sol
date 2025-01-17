pragma solidity ^0.8.0;

import "../FlashLoan.sol";
import "../../tokens/Tokens.sol";

import "forge-std/console.sol";

contract MultiProviderFlashLoanExample is FlashLoan, Tokens {
    function initiateAttack() external {
        deal(EthereumTokens.DAI, address(this), 1 ether);
        console.log("DAI BALANCE BEFORE:", EthereumTokens.DAI.balanceOf(address(this)));
        takeFlashLoan(FlashLoanProviders.EULER, address(EthereumTokens.DAI), 1 ether);
    }

    function _executeAttack() internal override {
        console.log("DAI BALANCE DURING:", EthereumTokens.DAI.balanceOf(address(this)));
        if (currentFlashLoanProvider() == FlashLoanProviders.EULER) {
            takeFlashLoan(FlashLoanProviders.AAVEV1, address(EthereumTokens.DAI), 1 ether);
        } else if (currentFlashLoanProvider() == FlashLoanProviders.AAVEV1) {
            // Execute attack with funds from EULER and AAVE
        }
    }

    function _completeAttack() internal override {
        console.log("DAI BALANCE AFTER :", EthereumTokens.DAI.balanceOf(address(this)));
    }
}
