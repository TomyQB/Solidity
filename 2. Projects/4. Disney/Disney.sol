// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";
import "./ERC20.sol";

contract Disney {
    using SafeMath for uint256;

    // Instancia del contrato token
    ERC20Basic private token;
    address payable public owner;

    // Estructura de datos para almacenar los clientes
    struct Cliente {
        uint256 tokens_comprados;
        string[] atracciones_disfrutadas;
    }

    // Mapping para el registro de clientes
    mapping(address => Cliente) public clientes;

    constructor() public {
        token = new ERC20Basic(100000);
        owner = msg.sender;
    }

    // Modificador para permitir que las funciones sean solo ejecutadas por la dirección que ha desplegado el contrato
    modifier OnlyOwner(address _owner) {
        require(
            keccak256(abi.encodePacked(_owner)) ==
                keccak256(abi.encodePacked(owner)),
            "No tiene permisos para realizar esa acción"
        );
        _;
    }

    // Modificador para comprobar que una atraccion existe
    modifier AtraccionExist(string memory _nombre) {
        require(
            keccak256(abi.encodePacked(atraccionesMap[_nombre].nombre)) ==
                keccak256(abi.encodePacked(_nombre)),
            "La atracción no existe"
        );
        _;
    }

    // Modificador para comprobar que la atracción está activada
    modifier AtraccionActiva(string memory _nombre) {
        require(
            keccak256(abi.encodePacked(atraccionesMap[_nombre].estado)) ==
                keccak256(abi.encodePacked(true)),
            "La atracción no está activada"
        );
        _;
    }

    // --------------------------------------------- GESTION DE TOKENS ---------------------------------------------

    // Funcion para establecer el precio de un token
    function precioTokens(uint256 _numTokens) internal pure returns (uint256) {
        // Conversion de tokens a ethers: 1 token = 1 eth
        return _numTokens * (1 ether);
    }

    // Funcion para comprar tokens
    function comprarTokens(uint256 _numTokens) external payable {
        // Establecer el precio de los tokens
        uint256 coste = precioTokens(_numTokens);

        // Se evalua el dinero que el cliente paga por los tokens
        require(msg.value >= coste, "Importe insuficiente");

        // Obtencion del numero de tokens disponibles
        uint256 balance = balanceOf();
        require(
            _numTokens <= balance,
            "Numero de tokens insuficientes, compra un numero menor"
        );

        // Se transfiere el numero de tokens al cliente
        token.transfer(msg.sender, _numTokens);

        // Almacenar en un registro los tokens comprado
        clientes[msg.sender].tokens_comprados += _numTokens;

        // Devolver el cambio
        uint256 returnValue = msg.value.sub(coste);
        // Disney retorna la cantidad de ethers al cliente
        msg.sender.transfer(returnValue);
    }

    // Balance de tokens del contrato disney
    function balanceOf() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Visualizar numero de tokens restantes de un cliente
    function misTokens() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }

    // Funcion para generar mas tokens
    function generaTokens(uint256 _numTokens) external OnlyOwner(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    // --------------------------------------------- GESTION DE DISNEY ---------------------------------------------

    event disfrutaAtraccion(string, uint256, address);
    event nuevaAtraccion(string);
    event bajaAtraccion(string);

    struct Atraccion {
        string nombre;
        uint256 precio;
        bool estado;
    }

    // Mapping para relacionar un nombre de una atraccion con una estructura de datos de la atraccion
    mapping(string => Atraccion) public atraccionesMap;
    // Array para almacenar el nombre de las atracciones
    string[] atracciones;

    // Mapping para relacionar una identidad (cliente) con su historial en DISNEY
    mapping(address => string[]) historialAtraccionesMap;

    function crearAtraccion(string calldata _nombre, uint256 _precio)
        external
        OnlyOwner(msg.sender)
    {
        atraccionesMap[_nombre] = Atraccion(_nombre, _precio, true);
        atracciones.push(_nombre);
        emit nuevaAtraccion(_nombre);
    }

    function darBajaAtraccion(string calldata _nombre)
        external
        OnlyOwner(msg.sender)
        AtraccionExist(_nombre)
    {
        atraccionesMap[_nombre].estado = false;
        emit bajaAtraccion(_nombre);
    }

    function verAtracciones() external view returns (string[] memory) {
        return atracciones;
    }

    // Funcion para subirse a una atraccion y pagar con tokens
    function subirAtraccion(string calldata _nombre)
        external
        AtraccionExist(_nombre)
        AtraccionActiva(_nombre)
    {
        // Precio de la atraccion
        uint256 tokens_atraccion = atraccionesMap[_nombre].precio;
        // Verificar que el cliente tiene suficientes tokens
        require(tokens_atraccion <= misTokens(), "No tiene suficientes tokens");
        /* El cliente paga la atraccion en tokens:
        - Ha sido necesario crear una funcion en ERC20.sol añadiendo un nuevo campo con la direccion del cliente
        debido a que en caso de usar el transfer que ya había en el contrato ERC20.sol las direcciones que se cogían
        para realizar la transaccion eran equivocadas. Ya que el msg.sender que recibía el metodo transfer era la
        direccion del owner, ya que el contrato ERC20.sol se crea en el constructor cuando lo despliega el owner.
        */
        token.transfer(msg.sender, address(this), tokens_atraccion);

        // Añadir atracción en el historial
        historialAtraccionesMap[msg.sender].push(_nombre);
        emit disfrutaAtraccion(_nombre, tokens_atraccion, msg.sender);
    }

    function verHistorial() external view returns (string[] memory) {
        return historialAtraccionesMap[msg.sender];
    }

    function devolverTokens(uint256 _numTokens) external payable {
        // El numero de tokens a devolver es positivo
        require(
            _numTokens > 0,
            "No se aceptan devoluciones de cantidades negativas"
        );
        // El usuario debe tener el numero de tokens que desea devolver
        require(_numTokens <= misTokens(), "No tiene suficientes tokens");

        // Devolucion de tokens
        token.transfer(msg.sender, address(this), _numTokens);

        // Devolucion de los ethers al cliente
        msg.sender.transfer(precioTokens(_numTokens));
    }

    // --------------------------------------------- GESTION DE COMIDA ---------------------------------------------

    struct Comida {
        string nombre;
        string[] ingredientes;
        uint8 precio;
    }

    mapping(string => Comida) public comidasMap;

    string[] comidas;

    mapping(address => string[]) historialComidasMap;

    function crearComida(
        string calldata _nombre,
        string[] calldata _ingredientes,
        uint8 _precio
    ) external {
        comidasMap[_nombre] = Comida(_nombre, _ingredientes, _precio);
        comidas.push(_nombre);
    }

    function addIngrediente(
        string calldata _nombre,
        string calldata _ingrediente
    ) external {
        comidasMap[_nombre].ingredientes.push(_ingrediente);
    }

    function verComidas() external view returns (string[] memory) {
        return comidas;
    }

    function comprarComida(string calldata _nombre) external {
        uint8 precio_tokens = comidasMap[_nombre].precio;
        require(precio_tokens <= misTokens(), "No tiene suficientes");

        token.transfer(msg.sender, address(this), precio_tokens);

        historialAtraccionesMap[msg.sender].push(_nombre);
    }
}
