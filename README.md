# Million dollar ether homepage

TODO

## Install

Uses Truffle 3.x. (globally)
```
npm install truffle -g
```

Requires Node > 0.7.x (and npm) (globally)

```
npm install
```

Create a `mnemonic` file at the root of the project
```
touch mnemonic.js
```

## Deployment (via Truffle)

To work locally  you will need a running instance of [testrpc](https://github.com/ethereumjs/testrpc).

To install `testrpc`
```
npm install -g ethereumjs-testrpc
```
* Once running lauch `testrpc` in a new shell

Deploying locally (to network: default):
```
truffle migrate
```

## Testing

```
truffle test
```

To deploy to the Ropsten test chain, you will need to add javascript file called `mnemonic.js` in the root of the project with your mnemonic seed (that has credit in the coinbase account).

* Creating a test coinbase account on the test network Ropsten
  * Create a MetaMask account OR Ehterum Wallet account ensuring you are on the Ropsten test network
  * Source it with test Ether so we have some [Gas](https://www.cryptocompare.com/coins/guides/what-is-the-gas-in-ethereum/)
    * MetaMask test Ether https://faucet.metamask.io/
    * Ethereum Wallet test Ether http://faucet.ropsten.be:3001/
  * Update the `mnemonic.js` with your test network seed that now should have some test Gas

The `mnemonic.js` should be like so (but with your mnemonic seed):
```
module.exports = "bottle alley hunt acid hello limb matter robust tiger salad educate coffee";
```

Deploying remotely (to Ropsten, for example):
```
truffle migrate --network ropsten
```


### Licensed under MIT.  

This code is licensed under MIT.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
