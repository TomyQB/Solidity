pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Keccak {
    function calculateHash(string memory _cadena)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_cadena));
    }

    function calculateHash2(
        string memory _cadena,
        uint256 _k,
        address _address
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_cadena, _k, _address));
    }

    function calculateHash3(
        string memory _cadena,
        uint256 _k,
        address _address
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(_cadena, _k, _address, "hola", uint256(2))
            );
    }
}
