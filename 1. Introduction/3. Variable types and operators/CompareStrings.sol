pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract compare_strings {
    function compare(string memory _j, string memory _i)
        public
        view
        returns (bool)
    {
        bytes32 hash_i = keccak256(abi.encodePacked(_i));
        bytes32 hash_j = keccak256(abi.encodePacked(_j));

        if (hash_i == hash_j) {
            return true;
        }
        return false;
    }
}
