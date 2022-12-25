pragma solidity >=0.4.4 <0.7.0;

contract time {
    // time
    uint256 public actual_time = now;
    uint256 public one_minute = 1 minutes;
    uint256 public two_hours = 2 hours;
    uint256 public much_days = 50 days;
    uint256 public one_week = 1 weeks;

    // operations
    function MoreSeconds() public view returns (uint256) {
        return now + 50 seconds;
    }

    function MoreHours() public view returns (uint256) {
        return now + two_hours;
    }
}
