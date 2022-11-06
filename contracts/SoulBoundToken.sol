// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SoulBoundToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _baseTokenURI;

    mapping(address => uint256[]) private _userInfo;

    mapping(uint256 => address) private _tokenIssuer;

    mapping(address => uint256[]) private _issuedTokens;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _tokenIssuer[tokenId] = msg.sender;
        _issuedTokens[msg.sender].push(tokenId);
        _userInfo[to].push(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(
            from == address(0) || (to == address(0) && from == msg.sender),
            "Err: token transfer is BLOCKED"
        );

        super._beforeTokenTransfer(from, to, tokenId);
    }

    function revokeCertificate(uint256 tokenId) public {
        _burn(tokenId);
        address issuer = _tokenIssuer[tokenId];
        delete _tokenIssuer[tokenId];
        for (uint256 i = 0; i < _issuedTokens[issuer].length; i++) {
            if (_issuedTokens[issuer][i] == tokenId) {
                _issuedTokens[issuer][i] = _issuedTokens[issuer][
                    _issuedTokens[issuer].length - 1
                ];
                break;
            }
        }
        _issuedTokens[issuer].pop();
        for (uint256 i = 0; i < _userInfo[msg.sender].length; i++) {
            if (_userInfo[msg.sender][i] == tokenId) {
                _userInfo[msg.sender][i] = _userInfo[msg.sender][
                    _userInfo[msg.sender].length - 1
                ];
                break;
            }
        }
        _userInfo[msg.sender].pop();
    }

    function getTokenIssuer(uint256 tokenId) public view returns (address) {
        return _tokenIssuer[tokenId];
    }

    function getTokensIssuedByAddress(address Issuer)
        public
        view
        returns (uint256[] memory)
    {
        return _issuedTokens[Issuer];
    }

    function getURIsFromAddress(address tokenOwner)
        public
        view
        returns (string[] memory)
    {
        string[] memory URIs = new string[](_userInfo[tokenOwner].length);
        for (uint256 i = 0; i < _userInfo[tokenOwner].length; i++) {
            URIs[i] = tokenURI(_userInfo[tokenOwner][i]);
        }
        return URIs;
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
