//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

struct NameStruct {
    address owner;
    address scName;
    string name;
}

interface iCLLEthereumBootcamp {
    function addName (address scNameAddress, string memory name) external returns (bool);
    function deleteName () external returns (bool);
    function existsOwner (address account) external view returns (bool);
    function getNameInfoByOwner(address account) external view returns (NameStruct memory);
    function owner () external view returns (address);
    function bootcampInfo() external view returns (string memory);
}

//Na hora de fazer deploy dessa interface tenho q especificar no botao At Address o endereço do contrato original com as funcoes que essa interface vai implementar.
//Se eu declarar na minha interface uma funcao QUE NAO EXISTE, QUANDO FOR CHAMADA essa funcao vai retornar ERRO.