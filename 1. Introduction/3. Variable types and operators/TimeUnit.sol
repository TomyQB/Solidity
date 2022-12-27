pragma solidity >=0.7.0 <0.9.0;

contract time {
    // time
    uint256 public actual_time = block.timestamp;
    uint256 public one_minute = 1 minutes;
    uint256 public two_hours = 2 hours;
    uint256 public much_days = 50 days;
    uint256 public one_week = 1 weeks;

    // operations
    function MoreSeconds() public view returns (uint256) {
        return block.timestamp + 50 seconds;
    }

    function MoreHours() public view returns (uint256) {
        return block.timestamp + two_hours;
    }
}
