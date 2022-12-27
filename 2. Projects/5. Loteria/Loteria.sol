// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";
import "./ERC20.sol";

contract Loteria {
    using SafeMath for uint256;

    event comprarTokensEvent(uint256 numTokens, address cliente);

    ERC20Basic private token;

    address owner;
    address contrato;

    uint256 tokensCreados = 10000;

    constructor() public {
        token = new ERC20Basic(tokensCreados);
        owner = msg.sender;
        contrato = address(this);
    }

    modifier OnlyOwner(address _direccion) {
        require(
            keccak256(abi.encodePacked(owner)) ==
                keccak256(abi.encodePacked(_direccion)),
            "No tiene permisos para ejecutar esa acción"
        );
        _;
    }

    // --------------------------------------------- GESTION DE TOKENS ---------------------------------------------

    function precioToken(uint256 _numTokens) internal pure returns (uint256) {
        return _numTokens * (1 ether);
    }

    function addTokens(uint256 _numTokens) external OnlyOwner(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    function balanceOf() public view returns (uint256) {
        return token.balanceOf(contrato);
    }

    function comprarTokens(uint256 _numTokens) external payable {
        uint256 coste = precioToken(_numTokens);

        require(msg.value >= coste, "No tiene suficiente eth");
        require(
            _numTokens <= balanceOf(),
            "No hay suficientes token, solicina un numero menor"
        );

        token.transfer(msg.sender, _numTokens);

        uint256 return_value = msg.value.sub(coste);
        msg.sender.transfer(return_value);
        emit comprarTokensEvent(_numTokens, msg.sender);
    }

    // Tokens acumulados en el bote
    function verBote() public view returns (uint256) {
        return token.balanceOf(owner);
    }

    function misTokens() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }

    // --------------------------------------------- LOTERIA ---------------------------------------------

    event comprarBoletoEvent(uint256, address);
    event boletoGanadorEvent(uint256);

    uint8 public precioBoleto = 5;

    mapping(address => uint256[]) personaBoletosMap;
    mapping(uint256 => address) boletoGanadroMap;

    uint256 randNonce = 0;

    uint256[] boletosVendidos;

    function comprarBoleto(uint256 _boletos) external {
        uint256 precio_boletos = _boletos * precioBoleto;
        require(
            precio_boletos <= misTokens(),
            "No tiene suficiente tokens para realizar la compra"
        );

        token.transfer(msg.sender, owner, precio_boletos);

        /*
        Coge la marca de tiempo actual, el msg.sender y un nonce (un número único). Se utiliza keccak256 para
        convertir estas entradas a un hash aleatorio, convertir ese hash a un uint y luego utilizamos % 10000
        para tomar los ultimos 4 digitos. Esto nos da una valor aleatorio entre 0000 y 9999.
        */
        for (uint256 i = 0; i < _boletos; i++) {
            uint256 random = uint256(
                keccak256(abi.encodePacked(now, msg.sender, randNonce))
            ) % 10000;
            randNonce++;
            personaBoletosMap[msg.sender].push(random);
            boletosVendidos.push(random);
            boletoGanadroMap[random] = msg.sender;
            emit comprarBoletoEvent(random, msg.sender);
        }
    }

    function misBoletos() external view returns (uint256[] memory) {
        return personaBoletosMap[msg.sender];
    }

    function generarGanadro() external OnlyOwner(msg.sender) {
        require(boletosVendidos.length > 0, "No se ha comprado ningún boleto");

        uint256 posicion_ganador = uint256(keccak256(abi.encodePacked(now))) %
            boletosVendidos.length;
        uint256 numero_ganador = boletosVendidos[posicion_ganador];
        emit boletoGanadorEvent(numero_ganador);
        address ganador = boletoGanadroMap[numero_ganador];

        token.transfer(owner, ganador, verBote());
    }

    function canjearTokens() external payable {
        uint256 tokens_devolver = misTokens();
        token.transfer(msg.sender, contrato, tokens_devolver);
        msg.sender.transfer(precioToken(tokens_devolver));
    }
}
