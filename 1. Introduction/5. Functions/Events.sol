pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Events {
    event event_1(string _nombrePersona);
    event event_2(string _nombrePersona, uint256 _edadPersona);
    event event_3(string, uint256, address, bytes32);
    event event_4();

    function EmitEvent1(string memory _nombrePersona) public {
        emit event_1(_nombrePersona);
    }

    function EmitEvent2(string memory _nombrePersona, uint256 _edad) public {
        emit event_2(_nombrePersona, _edad);
    }

    function EmitEvent3(string memory _nombrePersona, uint256 _edad) public {
        bytes32 hash_id = keccak256(
            abi.encodePacked(_nombrePersona, _edad, msg.sender)
        );
        emit event_3(_nombrePersona, _edad, msg.sender, hash_id);
    }

    function EmitEvent4() public {
        emit event_4();
    }
}
