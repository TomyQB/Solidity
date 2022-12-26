//SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  CANDIDATO   |   EDAD   |      ID
// -----------------------------------
//  Toni        |    20    |    12345X
//  Alberto     |    23    |    54321T
//  Joan        |    21    |    98765P
//  Javier      |    19    |    56789W

contract Votaciones {
    address owner;

    mapping(string => bytes32) candidatosMap;

    mapping(string => uint256) votosMap;

    string[] candidatos;

    bytes32[] candidatosAddres;

    bytes32[] votantes;

    constructor() public {
        owner = msg.sender;
    }

    modifier PrimerVoto(address _direccion) {
        for (uint256 i = 0; i < votantes.length; i++) {
            require(
                keccak256(abi.encodePacked(msg.sender)) != votantes[i],
                "No puede votar mas de 1 vez."
            );
        }
        _;
    }

    modifier CandidatoExiste(string memory _nombre) {
        require(candidatos.length > 0, "No hay candidatos");
        /*for(uint256 i = 0; i < candidatos.length; i++) {
            require(keccak256(abi.encodePacked(_nombre)) == keccak256(abi.encodePacked(candidatos[i])), "No existe el candidato.");
        }*/
        _;
    }

    modifier CandidatoPresentado(address _direccion) {
        for (uint256 i = 0; i < candidatosAddres.length; i++) {
            require(
                keccak256(abi.encodePacked(msg.sender)) != candidatosAddres[i],
                "No puede representar mas de 1 vez."
            );
        }
        _;
    }

    function representar(
        string calldata _nombre,
        string calldata _id,
        uint8 _edad
    ) external CandidatoPresentado(msg.sender) {
        candidatosMap[_nombre] = keccak256(
            abi.encodePacked(_nombre, _id, _edad)
        );
        candidatos.push(_nombre);
        candidatosAddres.push(keccak256(abi.encodePacked(msg.sender)));
    }

    function verCandidatos() external view returns (string[] memory) {
        return candidatos;
    }

    function votar(string calldata _nombre)
        external
        PrimerVoto(msg.sender)
        CandidatoExiste(_nombre)
    {
        votosMap[_nombre]++;
        votantes.push(keccak256(abi.encodePacked(msg.sender)));
    }

    function verVotos(string memory _nombre)
        public
        view
        CandidatoExiste(_nombre)
        returns (uint256)
    {
        return votosMap[_nombre];
    }

    function verEstadoVotacion() external view returns (string memory) {
        string memory resultados = "";

        for (uint256 i = 0; i < candidatos.length; i++) {
            resultados = string(
                abi.encodePacked(
                    resultados,
                    candidatos[i],
                    ": ",
                    uint2str(verVotos(candidatos[i]))
                )
            );
        }
        return resultados;
    }

    function verGanador() external view returns (string memory) {
        string memory ganador = candidatos[0];
        bool empate = false;

        for (uint256 i = 1; i < candidatos.length; i++) {
            if (votosMap[candidatos[i]] > votosMap[ganador]) {
                ganador = candidatos[i];
                empate = false;
            } else if (votosMap[candidatos[i]] == votosMap[ganador]) {
                empate = true;
            }
        }

        if (empate) {
            return "Ha habído un empate";
        }

        return ganador;
    }

    //Funcion auxiliar que transforma un uint a un string
    function uint2str(uint256 _i)
        private
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }
}
