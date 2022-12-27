pragma solidity >=0.7.0 <0.9.0;

contract casting {
    uint8 uint_8_bits = 42;
    uint64 uint_64_bits = 60000;
    uint256 uint_256_bits = 1000000;

    int16 int_16_bits = 15600;
    int120 int_120_bits = 900000;
    int256 int_256_bits = 5000;

    // casting
    uint64 public casting_1 = uint64(uint_8_bits);
    uint64 public casting_2 = uint64(uint_256_bits);
    int256 public casting_4 = int256(int_120_bits);

    function castTo64Bits(uint8 _number) public view returns (uint64) {
        return uint64(_number);
    }
}
