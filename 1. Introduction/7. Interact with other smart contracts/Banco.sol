pragma solidity >=0.7.0 <0.9.0;

contract Banco {
    struct Cliente {
        string _nombre;
        address direccion;
        uint256 dinero;
    }

    mapping(string => Cliente) clientesMap;

    function nuevoCliente(string memory _nombre) internal {
        clientesMap[_nombre] = Cliente(_nombre, msg.sender, 0);
    }
}

contract Banco2 {}
