pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Modifer {
    //Ejemplo de solo propietario del contrato puede ejecutar una funcion
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier soloPropietario() {
        require(
            msg.sender == owner,
            "No tienes permisos para ejecutar la funcion"
        );
        _;
    }

    function ejemplo1() public soloPropietario {
        //Codigo de la funcion parar el propietario del contrato
    }

    struct Cliente {
        address direccion;
        string nombre;
    }

    mapping(string => address) clientes;

    function altaCliente(string memory _nombre) public {
        clientes[_nombre] = msg.sender;
    }

    modifier soloClientes(string memory _nombre) {
        require(clientes[_nombre] == msg.sender);
        _;
    }

    function ejemplo2(string memory _nombre) public soloClientes(_nombre) {
        //Logica de la funcion para los clientes
    }

    //Ejemplo de conduccion
    modifier MayorEdad(uint256 _edadMinima, uint256 _edadUsuario) {
        require(_edadUsuario >= _edadMinima);
        _;
    }

    function conducir(uint256 _edad) public MayorEdad(18, _edad) {
        //Codigo a ejecutar para los conductores mayores de edad
    }
}
