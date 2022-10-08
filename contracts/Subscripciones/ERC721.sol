// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
// import {ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol"; //"@superfluid-finance/ethereum-monorepo/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {IConstantFlowAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import {CFAv1Library, ISuperfluid, ISuperfluidToken} from "@superfluid-finance/ethereum-contracts/contracts/apps/CFAv1Library.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import "@superfluid-finance/ethereum-contracts/contracts/tokens/SETH.sol";

contract MyToken is
    ERC721,
    ERC721Enumerable,
    Pausable,
    Ownable,
    ERC721Burnable
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    /// @notice CFA Library.
    using CFAv1Library for CFAv1Library.InitData;
    CFAv1Library.InitData public cfaV1;
    ISuperfluidToken chainToken;
    ISuperfluidToken usdToken;
    uint256 cost;
    address vault;

    AggregatorV3Interface internal priceFeed;

    constructor(
        ISuperfluid host,
        uint256 _cost,
        address _vault,
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
<<<<<<< HEAD
        chainToken = '';
        usdToken = 0xde637d4c445ca2aae8f782ffac8d2971b93a4998;
=======

>>>>>>> 3e5145e13e0bd8d81481f414d21d8d75fe05069a
        cost = _cost;
        vault = _vault;
        // Initialize CFA Library
        cfaV1 = CFAv1Library.InitData(
            host,
            IConstantFlowAgreementV1(
                address(
                    host.getAgreementClass(
                        keccak256(
                            "org.superfluid-finance.agreements.ConstantFlowAgreement.v1"
                        )
                    )
                )
            )
        );
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(string memory _coin, uint duration) public {
        uint secs = duration*24*60*60;
        uint ethPrice = uint(getLatestPrice());
        uint conversion = cost/ethPrice;
        uint flowrate = price/secs;
        string memory eth = "ETH";
        string memory usd = "USD";
        if (keccak256(abi.encodePacked((_coin))) == keccak256(abi.encodePacked((eth)))) {
        uint upgraded = upgradeByETH(cost);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        cfaV1.createFlowByOperator(chainToken, msg.sender, vault, flowRate, new bytes(0));
        _safeMint(msg.sender, tokenId);
        } else if (keccak256(abi.encodePacked((_coin))) == keccak256(abi.encodePacked((usd)))) {
        uint upgraded = upgrade(cost);
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment(); 
        cfaV1.createFlowByOperator(usdToken, msg.sender, vault, flowRate, new bytes(0));
        _safeMint(msg.sender, tokenId);
        } 


    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

        function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }
}
