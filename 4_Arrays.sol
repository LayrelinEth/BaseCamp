// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract ArraysExercise {
    uint[] numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; // Array of numbers initialized with values
    uint[] timestamps; // Dynamic array to store timestamps
    address[] senders; // Dynamic array to store sender addresses

    uint256 constant Y2K = 946702800; // Constant representing the Unix timestamp for the year 2000

    function getNumbers() external view returns (uint[] memory) {
        // Create a memory array to hold the numbers
        uint[] memory results = new uint[](numbers.length);

        // Copy the numbers from the state array to the memory array
        for(uint i=0; i<numbers.length; i++) {
            results[i] = numbers[i];
        }

        // Return the memory array
        return results;
    }

    function resetNumbers() public {
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    function appendToNumbers(uint[] calldata _toAppend) public {
        // Iterate through the array to be appended
        for (uint i = 0; i < _toAppend.length; i++) {
            // Push each element of the array to be appended to the numbers array
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint _unixTimestamp) public {
        // Push the timestamp and sender's address to their respective arrays
        timestamps.push(_unixTimestamp);
        senders.push(msg.sender);
    }

    function afterY2K() public view returns (uint256[] memory, address[] memory) {
        // Initialize counter for timestamps after Y2K
        uint256 counter = 0;

        // Count the number of timestamps after Y2K
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K) {
                counter++;
            }
        }
  
        uint256[] memory timestampsAfterY2K = new uint256[](counter);
        address[] memory sendersAfterY2K = new address[](counter);

        uint256 index = 0;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K) {
                timestampsAfterY2K[index] = timestamps[i];
                sendersAfterY2K[index] = senders[i];
                index++;
            }
        }

        return (timestampsAfterY2K, sendersAfterY2K);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }
}