pragma solidity >=0.4.4 <0.9.0;
pragma experimental ABIEncoderV2;

contract Factory {
    mapping(address => address) public miContratoPersonal;

    function factory() public {
        address direccionNuevoContrato = address(
            new SmartContract1(msg.sender)
        );
        miContratoPersonal[msg.sender] = direccionNuevoContrato;
    }
}

contract SmartContract1 {
    address public owner;

    constructor(address _direccion) public {
        owner = _direccion;
    }
}
