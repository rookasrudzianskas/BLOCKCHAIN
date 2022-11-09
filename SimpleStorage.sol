// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8; // This is a comment
// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;


contract SimpleStorage {
    // boolean, uint, int, address, bytes
    // This gets initialized with 0 value, this means, that this section is a comment
    uint256 favoriteNumber;

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // creates an array
    // uint256[] public favoriteNumbersList
    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // View and pure does not need spend crypto to work -> read functions
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    // calldata, memory, storage || storage exists everywhere
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
// 0xd9145CCE52D386f254917e481eB44e9943F39138
