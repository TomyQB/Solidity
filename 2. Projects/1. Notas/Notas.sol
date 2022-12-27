//SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract Notas {

    address public profesor;

    constructor () public {
        profesor = msg.sender;
    }

    // Mapping para relacionar el hash de la identidad del alumno con su nota de examen
    mapping (bytes32 => uint256) notas;

    // Array para los alumnos que quieran revisión de examen
    string[] revisiones;

    event alumnoEvaluado(bytes32);
    event alumnoRevision(string);

    modifier UnicamenteProfesor(address _direccion) {
        require(keccak256(abi.encodePacked(_direccion)) == keccak256(abi.encodePacked(profesor)), "No tienes permisos para ejecutar esta función");
        _;
    }

    function evaluar(string calldata _idAlumno, uint256 _nota) external UnicamenteProfesor(msg.sender) {
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        notas[hash_idAlumno] = _nota;
        emit alumnoEvaluado(hash_idAlumno);
    }

    function verNotas(string calldata _idAlumno) external view returns(uint256) {
        return notas[keccak256(abi.encodePacked(_idAlumno))];
    }

    function revision(string calldata _idAlumno) external {
        revisiones.push(_idAlumno);
        emit alumnoRevision(_idAlumno);
    }

    function verRevisiones() external view UnicamenteProfesor(msg.sender) returns(string[] memory) {
        return revisiones;
    }

}