# Junction2022-contracts
Smart contracts for Junction 2022 hackathon

## Development

1. Clone the project

       git clone git@github.com:kqlski/Junction2022-contracts.git

2. `npm install` and `npm install -g truffle`

3. run `truffle develop` followed by `build` and `migrate`


## Deployment

1. paste your mneumonic (secret phrase) inside `.secret`-file (Be careful with this!)

2. for the Testnet, run `truffle migrate --network testnet`

3. for the Mainnet, run `truffle migrate --network bscMainnet` (NOTE: this will charge actual BNB from your wallet).
