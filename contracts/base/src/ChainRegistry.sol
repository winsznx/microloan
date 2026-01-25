// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MicroLoan
 * @notice P2P lending with collateral management
 */
contract MicroLoan {
    error InsufficientCollateral();
    error LoanNotFound();
    error AlreadyRepaid();

    event LoanCreated(uint256 indexed loanId, address indexed borrower, uint256 amount);
    event LoanRepaid(uint256 indexed loanId);
    event CollateralClaimed(uint256 indexed loanId, address indexed lender);

    struct Loan {
        address borrower;
        address lender;
        uint256 amount;
        uint256 collateral;
        uint256 dueDate;
        bool repaid;
    }

    mapping(uint256 => Loan) public loans;
    uint256 public loanCounter;
    uint256 public collateralRatio = 150; // 150%

    function requestLoan(uint256 amount, uint256 duration) external payable returns (uint256) {
        uint256 requiredCollateral = (amount * collateralRatio) / 100;
        if (msg.value < requiredCollateral) revert InsufficientCollateral();
        
        uint256 loanId = loanCounter++;
        loans[loanId] = Loan({
            borrower: msg.sender,
            lender: address(0),
            amount: amount,
            collateral: msg.value,
            dueDate: block.timestamp + duration,
            repaid: false
        });
        
        emit LoanCreated(loanId, msg.sender, amount);
        return loanId;
    }

    function fundLoan(uint256 loanId) external payable {
        Loan storage loan = loans[loanId];
        if (loan.borrower == address(0)) revert LoanNotFound();
        require(msg.value == loan.amount);
        loan.lender = msg.sender;
        payable(loan.borrower).transfer(loan.amount);
    }

    function repay(uint256 loanId) external payable {
        Loan storage loan = loans[loanId];
        if (loan.repaid) revert AlreadyRepaid();
        require(msg.value == loan.amount);
        loan.repaid = true;
        payable(loan.lender).transfer(msg.value);
        payable(loan.borrower).transfer(loan.collateral);
        emit LoanRepaid(loanId);
    }

    function claimCollateral(uint256 loanId) external {
        Loan storage loan = loans[loanId];
        require(block.timestamp > loan.dueDate && !loan.repaid);
        require(msg.sender == loan.lender);
        payable(loan.lender).transfer(loan.collateral);
        emit CollateralClaimed(loanId, loan.lender);
    }

    function getLoan(uint256 loanId) external view returns (address, address, uint256, uint256, uint256, bool) {
        Loan memory loan = loans[loanId];
        return (loan.borrower, loan.lender, loan.amount, loan.collateral, loan.dueDate, loan.repaid);
    }
}
