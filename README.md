<h1 align="left">Chainlink-Bootcamp PT-BR 2023</h1>
Arquivos criados ao longo do Brazilian Chainlink Bootcamp em fev/2023.
</br></br>
> Project Status: Completed :heavy_check_mark: 

## Project Description
<p align="justify">Os contratos abaixo tem por objetivo atender as seguintes soluções:

- Tokenização + conversão de valores com Chainlink Price Feed
    - Criação de um token e um contrato para venda deste token. Utilização do Chainlink Price Feed para conversão de ETH/USD
- NFT Dinâmico com Chainlink Automation + IPFS
    - Criação de uma coleção de NFTs dinâmicos, atualizado por tempo, com imagens hospedadas no IPFS.
- NFT Game com Chainlink VRF
    - Criação de 3 NFTs armazenados no próprio smart contract, os metadados com a distância percorrida dos personagens são atualizados a cada chamada da função Run(), com valores randômicos fornecidos pelo Chainlink Verified Random Function.
    
</p>

### Smart Contracts
Abaixo a lista de contratos envolvidos em cada solução.

- :dollar: Token Shop
    - TokenMultiSys.sol, TokenShop.sol
- :art: NFT Dinâmico com Chainlink Automation
    - Flower.sol
- :game_die: NFT com Chainlink VRF
    - NFTRunners.sol  
    
## Deploy dos Smart Contracts na Goerli Testnet:

*Contratos*

> https://goerli.etherscan.io/address/0x22d43348deb6d8b7d41adcb479b0d081eda45ca6 - Flower.sol
> https://goerli.etherscan.io/address/0xcd3E68C565e57d95586ab63B2C2B7ad4AD77A50A - NFTRunners.sol

*Visualização no Opensea*

>  https://testnets.opensea.io/assets/goerli/0x22d43348deb6d8b7d41adcb479b0d081eda45ca6/0 - Flower.sol
>  https://testnets.opensea.io/assets/goerli/0xcd3E68C565e57d95586ab63B2C2B7ad4AD77A50A/0 - NFTRunners.sol
