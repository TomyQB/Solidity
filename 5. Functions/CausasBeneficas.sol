/* 1. Dar de alta causas benéficas.
   2. Dar dinero a una causa benéfica.
   3. Consultar si una causa ha llegado a objetivo de dinero.
*/

pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract CausasBeneficas {
    struct CausaBenefica {
        bytes32 id;
        string name;
        uint256 objetivo;
        uint256 recaudado;
    }

    mapping(bytes32 => CausaBenefica) causasMap;

    function createCausa(string memory _name, uint256 _objetivo) public {
        bytes32 _id = keccak256(abi.encodePacked(_name, _objetivo));
        causasMap[_id] = CausaBenefica(_id, _name, _objetivo, 0);
    }

    function donar(bytes32 _id, uint256 _cantidad) public returns (bool) {
        if (checkObjetivo(_id)) {
            causasMap[_id].recaudado = causasMap[_id].recaudado + _cantidad;
            return true;
        }
        return false;
    }

    function checkObjetivo(bytes32 _id) public view returns (bool) {
        return causasMap[_id].recaudado < causasMap[_id].objetivo;
    }
}
