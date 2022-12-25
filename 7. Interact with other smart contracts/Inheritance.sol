pragma solidity >=0.4.4 <0.7.0;

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

contract Cliente is Banco {
    function AltaCliente(string memory _nombre) public {
        nuevoCliente(_nombre);
    }

    function ingresarDinero(string memory _nombre, uint256 _cantidad) public {
        clientesMap[_nombre].dinero += _cantidad;
    }

    function retirarDinero(string memory _nombre, uint256 _cantidad)
        public
        returns (bool)
    {
        if (_cantidad <= clientesMap[_nombre].dinero) {
            clientesMap[_nombre].dinero -= _cantidad;
            return true;
        }
        return false;
    }

    function getDinero(string memory _nombre) public view returns (uint256) {
        return clientesMap[_nombre].dinero;
    }
}