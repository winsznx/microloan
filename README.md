# MicroLoan

P2P lending protocol with collateral management on Base and Stacks blockchains.

## Features

- Request loans with collateral backing
- 150% collateralization ratio
- Peer-to-peer loan funding
- Automatic collateral liquidation on default
- Multi-chain lending

## Smart Contract Functions

### Base (Solidity)
- `requestLoan(uint256 amount, uint256 duration)` - Request loan with collateral
- `fundLoan(uint256 loanId)` - Fund a loan request
- `repay(uint256 loanId)` - Repay loan and reclaim collateral
- `claimCollateral(uint256 loanId)` - Claim collateral on default
- `getLoan(uint256 loanId)` - Get loan details

### Stacks (Clarity)
- `(request-loan (amount uint) (duration uint) (collateral uint))` - Request loan
- `(get-loan (loan-id uint))` - Get loan info

## Tech Stack

- **Frontend**: Next.js 14, TypeScript, Tailwind CSS
- **Base**: Solidity 0.8.20, Foundry, Reown wallet
- **Stacks**: Clarity v4, Clarinet, @stacks/connect

## Getting Started

```bash
pnpm install
pnpm dev
```

## License

MIT License
