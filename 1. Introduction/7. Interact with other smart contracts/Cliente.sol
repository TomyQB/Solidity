pragma solidity >=0.7.0 <0.9.0;
// import "./Banco.sol";
import {Banco} from "./Banco.sol";

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
