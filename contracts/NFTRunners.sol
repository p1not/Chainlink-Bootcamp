//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
//Exemplo de jogo utilizando NFT e VRF para gerar valores aleatorios
//https://testnets.opensea.io/assets/goerli/0xcd3E68C565e57d95586ab63B2C2B7ad4AD77A50A/0
//9929 - ID Subscription - Chainlink VRF

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract NftRunners is ERC721, ERC721URIStorage, VRFConsumerBaseV2 {
    using Counters for Counters.Counter;
    using Strings for uint256;

    //VRF
    VRFCoordinatorV2Interface COORDINATOR;
    // Goerli coordinator
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    uint32 callbackGasLimit = 2500000;
    uint16 requestConfirmations = 3;    //minimo de blocos para se esperar para recer o numero randomico. Se menor q 3 da erro.
    uint32 numWords =  1;               //qnts numeros randomicos quero receber do VRF
    uint64 public s_subscriptionId;
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;

    //NFT
    Counters.Counter public tokenIdCounter;
    string[] characters = [
        "https://ipfs.io/ipfs/QmTgqnhFBMkfT9s8PHKcdXBn1f5bG3Q5hmBaR4U6hoTvb1?filename=Chainlink_Elf.png",
        "https://ipfs.io/ipfs/QmZGQA92ri1jfzSu61JRaNQXYg1bLuM7p8YT83DzFA2KLH?filename=Chainlink_Knight.png",
        "https://ipfs.io/ipfs/QmW1toapYs7M29rzLXTENn3pbvwe8ioikX1PwzACzjfdHP?filename=Chainlink_Orc.png",
        "https://ipfs.io/ipfs/QmPMwQtFpEdKrUjpQJfoTeZS1aVSeuJT6Mof7uV29AcUpF?filename=Chainlink_Witch.png"
    ];

    struct Runner {
        string image;
        uint256 distance;
    }
    Runner[] public runners;

    constructor(uint64 subscriptionId) ERC721("RunnerNFT", "RUN") VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;

        safeMint(msg.sender,0);     //ja crio o 1 personagem informando a posiçao dele no array
    }

    function safeMint(address to, uint256 charId) public {
        uint8 aux = uint8 (charId);
        require( (aux >= 0) && (aux <= 3), "invalid charId");
        string memory yourCharacterImage = characters[charId];

        runners.push(Runner(yourCharacterImage,0));

        uint256 tokenId = tokenIdCounter.current();
        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "RunnerNFT",',
                        '"description": "This is your character",',
                        '"image": "', runners[tokenId].image, '",'
                        '"attributes": [',
                        '{',
                            '"trait_type": "distance",',
                            '"value": ', runners[tokenId].distance.toString(),
                            '}]'
                        '}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );
        tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, finalTokenURI);
    }

    //somente o ultimo personagem criado e q vai correr pois quando clico em Run() vai pedir uma o numero aleatorio e quando volta a resposta pela fulfillRandomWords, so atualiza pro ultimo personagem
    function run() public {
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    //SOU OBRIGADO A TER ESSA FUNCAO COM ESSE NOME PORQUE O COORDENATOR DA CHAINLINK VAI RESPONDER COM O NUMERO ALEATORIO PARA ESSA FUNCAO
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        require (tokenIdCounter.current() >= 0, "You must mint a NFT");
        s_randomWords = randomWords;
        uint aux = (s_randomWords[0] % 10 + 1) * 10;
        uint256 tokenId = tokenIdCounter.current()-1;       //so o umtimo personagem criado q sera atualizado
        runners[tokenId].distance += aux;

        string memory uri = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "RunnerNFT",',
                        '"description": "This is your character",',
                        '"image": "', runners[tokenId].image, '",'
                        '"attributes": [',
                        '{',
                            '"trait_type": "distance",',
                            '"value": ', runners[tokenId].distance.toString(),
                            '}]'
                        '}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", uri)
        );
        _setTokenURI(tokenId, finalTokenURI);
    }
    
    // The following functions are overrides required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    //Outra forma de se armazenar os dados do NFT e' no proprio contrato, o oposto dos exemplo de NFT dinamico com IPFS
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}