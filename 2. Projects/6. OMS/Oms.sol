// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Oms {
    event solicitudAccesoEvent(address);
    event centroValidadoEvent(address);
    event nuevoContratoEvent(address, address);

    address oms;

    // Mapping para relacionar los centros de salud (addres) con su validez del sistema de gestion
    mapping(address => bool) centrosPermitidosMap;
    mapping(address => address) centroContratoMap;

    address[] solicitudes;

    constructor() {
        oms = msg.sender;
    }

    modifier OnlyOms(address _direccion) {
        require(
            keccak256(abi.encodePacked(_direccion)) ==
                keccak256(abi.encodePacked(oms)),
            "No tienes permisos para ejecutar esa accion"
        );
        _;
    }

    modifier CentroValidado(address _direccion) {
        require(
            keccak256(abi.encodePacked(centrosPermitidosMap[_direccion])) ==
                keccak256(abi.encodePacked(true)),
            "Su centro aun no esta validado"
        );
        _;
    }

    function validarCentro(address _centroSalud) external OnlyOms(msg.sender) {
        centrosPermitidosMap[_centroSalud] = true;
        emit centroValidadoEvent(_centroSalud);
    }

    function crearContratos() external CentroValidado(msg.sender) {
        // Generar un Smart Contract -> Generar su direccion
        address contrato_centroSalud = address(new CentroSalud(msg.sender));
        centroContratoMap[msg.sender] = contrato_centroSalud;
        emit nuevoContratoEvent(contrato_centroSalud, msg.sender);
    }

    function solicitarValidacion() external {
        solicitudes.push(msg.sender);
        emit solicitudAccesoEvent(msg.sender);
    }

    function verSolicitudes()
        external
        view
        OnlyOms(msg.sender)
        returns (address[] memory)
    {
        return solicitudes;
    }

    function comprobarValidacion() external view returns (bool) {
        return centrosPermitidosMap[msg.sender];
    }

    function verMiContrato() external view returns (address) {
        return centroContratoMap[msg.sender];
    }
}

// Qmb9d3o8kdwqUL3nL3rzEuP5hGAHNXh6E38SreyF361UUL

contract CentroSalud {
    address owner;

    struct Diagnostico {
        bool isPositivo;
        string codigoIPFS;
    }

    mapping(bytes32 => Diagnostico) diagnosticoCovidMap;

    event nuevoResultadoEvent(bool, string);

    constructor(address _direccion) {
        owner = _direccion;
    }

    modifier OnlyOwner(address _direccion) {
        require(
            keccak256(abi.encodePacked(_direccion)) ==
                keccak256(abi.encodePacked(owner)),
            "No tienes permisos para ejecutar esa accion"
        );
        _;
    }

    function emitirResultado(
        string memory _persona,
        bool _resultado,
        string memory _codigoIPFS
    ) external OnlyOwner(msg.sender) {
        bytes32 hash_persona = keccak256(abi.encodePacked(_persona));
        diagnosticoCovidMap[hash_persona] = Diagnostico(
            _resultado,
            _codigoIPFS
        );
        emit nuevoResultadoEvent(_resultado, _codigoIPFS);
    }

    function verResultados(string memory _persona)
        external
        view
        returns (Diagnostico memory)
    {
        return diagnosticoCovidMap[keccak256(abi.encodePacked(_persona))];
    }
}
