pragma solidity >=0.4.4 <0.7.0;

contract GlobalFunctions {
    // Address de quien ha ejecutado la función
    function MsgSender() public view returns (address) {
        return msg.sender;
    }

    // Tiempo en segundos
    function Now() public view returns (uint256) {
        return now;
    }

    // Address del minero que está procesando el bloque actual
    function BlockCoinbase() public view returns (address) {
        return block.coinbase;
    }

    // Difucultad
    function BlockDifficulty() public view returns (uint256) {
        return block.difficulty;
    }

    // Número de bloque
    function BlockNumber() public view returns (uint256) {
        return block.number;
    }

    // Identificador de la función, primeros 4 bytes de los datos enviados en la transacción
    function MsgSig() public view returns (bytes4) {
        return msg.sig;
    }

    // Precio del gas de la transacción
    function txGasPrice() public view returns (uint256) {
        return tx.gasprice;
    }
}
