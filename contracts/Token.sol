// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20CappedUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20PausableUpgradeable.sol";
 
contract TokenV1 is ERC20CappedUpgradeable {

    uint s;

    function initialize() public {
        __ERC20_init("TokenV1", "TV1");
        __ERC20Capped_init(10e18);
    }
}

contract TokenV2Bad is ERC20CappedUpgradeable, ERC20PausableUpgradeable {

    // this storage variable is displaced by the introduction of ERC20Pausable
    uint s;

    function initialize() public {
        __ERC20_init("TokenV1", "TV1");
        __ERC20Capped_init(10e18);
        __ERC20Pausable_init();
    }

    // needed by solidity when combining capped + pausable
    // see Using Hooks: https://docs.openzeppelin.com/contracts/3.x/extending-contracts#using-hooks
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual override(ERC20CappedUpgradeable, ERC20PausableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}


contract TokenState {
    uint s;
}

contract TokenV2Good is ERC20CappedUpgradeable, TokenState, ERC20PausableUpgradeable {

    function initialize() public {
        __ERC20_init("TokenV1", "TV1");
        __ERC20Capped_init(10e18);
        __ERC20Pausable_init();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual override(ERC20CappedUpgradeable, ERC20PausableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}

// TokenState can't grow, can only append to the end of the inheritance list

contract TokenStateExtension {
    uint z1;
    uint z2;
}

contract TokenV3 is ERC20CappedUpgradeable, TokenState, ERC20PausableUpgradeable, TokenStateExtension {

    function initialize() public {
        __ERC20_init("TokenV1", "TV1");
        __ERC20Capped_init(10e18);
        __ERC20Pausable_init();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual override(ERC20CappedUpgradeable, ERC20PausableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}

// or a more future proof alternative can be used from the beginning
// see Storage Gaps: https://docs.openzeppelin.com/contracts/3.x/upgradeable#storage_gaps

contract TokenStateBetterV1 {
    uint s;

    uint[50] private __gap;
}

contract TokenStateBetterV2 {
    uint s;

    uint z1;
    uint z2;

    uint[48] private __gap;
}

// caveat: upgrades plugins will complain if gap size is changed. this will be fixed in a future release
