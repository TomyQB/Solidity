pragma solidity >=0.4.4 <0.7.0;

contract Comida {
    struct Plato {
        string nombre;
        string ingredientes;
        uint256 tiempo;
    }

    Plato[] platos;
    mapping(string => string) ingredientes;

    function nuevoPlato(
        string memory _nombre,
        string memory _ingredientes,
        uint256 _tiempo
    ) internal {
        platos.push(Plato(_nombre, _ingredientes, _tiempo));
        ingredientes[_nombre] = _ingredientes;
    }

    function getIngredientes(string memory _nombre)
        internal
        view
        returns (string memory)
    {
        return ingredientes[_nombre];
    }
}

contract Sandwitch is Comida {
    function sandwitch(string calldata _ingredientes, uint256 _tiempo)
        external
    {
        nuevoPlato("Sandwitch", _ingredientes, _tiempo);
    }

    function getIngredientes() external view returns (string memory) {
        return getIngredientes("Sandwitch");
    }
}
