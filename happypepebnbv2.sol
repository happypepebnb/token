/**
 *Submitted for verification at BscScan.com on 2024-02-10
*/

// SPDX-License-Identifier: GPL-3.0

// https://happypepe.site
// https://t.me/HappyPepeToken
// https://pepenomicon.com

pragma solidity 0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

library Address {
    error AddressInsufficientBalance(address account);
    error AddressEmptyCode(address target);
    error FailedInnerCall();

    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert AddressInsufficientBalance(address(this));
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert FailedInnerCall();
        }
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCallWithValue(target, data, 0);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert AddressInsufficientBalance(address(this));
        }
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResultFromTarget(target, success, returndata);
    }

    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    function verifyCallResult(bool success, bytes memory returndata)
        internal
        pure
        returns (bytes memory)
    {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    function _revert(bytes memory returndata) private pure {
        if (returndata.length > 0) {
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert FailedInnerCall();
        }
    }
}

library EnumerableSet {
    struct Set {
        bytes32[] _values;
        mapping(bytes32 => uint256) _positions;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            set._positions[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        uint256 position = set._positions[value];

        if (position != 0) {
            uint256 valueIndex = position - 1;
            uint256 lastIndex = set._values.length - 1;
            if (valueIndex != lastIndex) {
                bytes32 lastValue = set._values[lastIndex];
                set._values[valueIndex] = lastValue;
                set._positions[lastValue] = position;
            }
            set._values.pop();
            delete set._positions[value];
            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value)
        private
        view
        returns (bool)
    {
        return set._positions[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index)
        private
        view
        returns (bytes32)
    {
        return set._values[index];
    }

    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    struct Bytes32Set {
        Set _inner;
    }

    function add(Bytes32Set storage set, bytes32 value)
        internal
        returns (bool)
    {
        return _add(set._inner, value);
    }

    function remove(Bytes32Set storage set, bytes32 value)
        internal
        returns (bool)
    {
        return _remove(set._inner, value);
    }

    function contains(Bytes32Set storage set, bytes32 value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, value);
    }

    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(Bytes32Set storage set, uint256 index)
        internal
        view
        returns (bytes32)
    {
        return _at(set._inner, index);
    }

    function values(Bytes32Set storage set)
        internal
        view
        returns (bytes32[] memory)
    {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;
        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }
        return result;
    }

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    function remove(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    function contains(AddressSet storage set, address value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index)
        internal
        view
        returns (address)
    {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    function values(AddressSet storage set)
        internal
        view
        returns (address[] memory)
    {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;
        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }
        return result;
    }

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(value));
    }

    function contains(UintSet storage set, uint256 value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(value));
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(UintSet storage set, uint256 index)
        internal
        view
        returns (uint256)
    {
        return uint256(_at(set._inner, index));
    }

    function values(UintSet storage set)
        internal
        view
        returns (uint256[] memory)
    {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;
        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }
        return result;
    }
}

interface IPancakeFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IPancakePair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

library PancakeLibrary {
    function sortTokens(address tokenA, address tokenB)
        internal
        pure
        returns (address token0, address token1)
    {
        require(tokenA != tokenB, "PancakeLibrary: IDENTICAL_ADDRESSES");
        (token0, token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "PancakeLibrary: ZERO_ADDRESS");
    }

    function pairFor(
        address factory,
        address tokenA,
        address tokenB
    ) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex"ff",
                            factory,
                            keccak256(abi.encodePacked(token0, token1)),
                            hex"d0d4c4cd0848c93cb4fd1f498d7013ee6bfb25783ea21593d5834f5d250ece66" // init code hash
                        )
                    )
                )
            )
        );
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        _status = NOT_ENTERED;
    }

    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

contract HappyPepeBNBv2 is IERC20, ReentrancyGuard, Context {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    EnumerableSet.AddressSet private _holders;
    EnumerableSet.AddressSet private _users;
    EnumerableSet.AddressSet private _bots;

    string private _name = "Happy Pepe BNB v2";
    string private _symbol = "HPYPEPE";
    uint8 private _decimals = 18;

    struct Addresses {
        address payable owner;
        address payable admin;
        address burner;
        address jackpot;
        address game;
        address api;
        address proc;
        address safu;
    }
    Addresses private addr;

    struct Vars {
        bool tradingEnabled;
        bool bonusPaused;
        bool bonusEnabled;
        bool[5] autos;
        uint256 maxLedger;
        uint256 minHolders;
        uint256 eligibleBonus;
        uint256 eligiblePlay;
        uint256[5] threshold;
    }
    Vars private vars =
        Vars(
            false,
            false,
            true,
            [true, false, true, true, true],
            5000000000 ether,
            20,
            100000000 ether,
            100000000 ether,
            [
                uint256(500000000 ether),   // burn
                1000000000 ether,           // swap
                250000000000000000,         // fees
                100000000 ether,            // bonus
                1000000000 ether            // jackpot
            ]
        );

    IPancakeRouter02 private router;
    IPancakePair private pair;
    address private _pair;

    struct Bools {
        bool kf;
        bool kt;
        bool ko;
        bool ks;
        bool ef;
        bool et;
        bool eo;
        bool es;
        bool bf;
        bool bt;
        bool bo;
        bool bs;
    }

    struct Total {
        uint256 supply;     // total supply
        uint256 fees;       // total fees collected
        uint256 feeTokens;  // total fee tokens sold
        uint256 feeEthers;  // total fee collected in BNB
        uint256 minsupply;  // min supply
        uint256 maxsupply;  // max supply
        uint256 holders;    // total holders
        uint256 users;      // registered users
        uint256 burned;     // total burned
    }
    Total private total =
        Total(
            1000000000000 ether,
            252556292119186765072703907094, // v1 total fees collected
            113000000000000000000000000000, // v1 total fee tokesn sold
            4505573595595306564,            // v1 total BNB from fees
            500000000000 ether,             // min supply / burn stops
            1000000000000 ether,            // max supply of tokens
            0,                              // total holders count
            0,                              // total registered users
            0                               // total tokens burned
        );

    struct JackpotOpt {
        uint256[5] levels;  // 1 in x
        uint256[5] percent; // percent of jackpot in * 100 (0.01% = 1)
    }
    JackpotOpt private jopt =
        JackpotOpt(
            [uint256(1), 4, 64, 384, 1024],
            [uint256(9), 28, 217, 2645, 7110]
        );

    struct Jackpot {
        uint256 draws;      // total jackpot draws
        uint256 payout;     // total jackpot payout
        uint256 topwin;     // top jackpot won
        uint256[5] hits;    // total hits per level
        uint256[5] last;    // last hit timestamp per level
        uint256[5] wins;    // total payouts per level
    }
    Jackpot private jackpot;

    struct Bonus {
        uint256 rndRange;
        uint256 toHit;
        uint256 percent;
        uint256 delay;
        uint256 execs;
        uint256 hits;
        uint256 miss;
        uint256 fail;
        uint256 nextBlock;
        uint256 available;
        uint256 payouts;
    }
    Bonus private bonus =
        Bonus(
            9,      // range
            5,      // to hit
            20,     // ledger percent pyout
            50,     // block delay
            652,    // bonos executions
            81,     // bonus hits
            571,    // bonus miss
            6,      // winner didn't have ledger balance
            0,      // next block
            0,      // available for bonus
            19511292921489599999062537292 // v1 total bonus payout
        );

    struct Next {
        bool bonus;
        address holder;
        uint256 random;
        uint256 percent;
        uint256 amount;
        uint256 toHit;
        uint256 blockNo;
    }
    Next private next;

    struct TxOp {
        bool buy;
        bool sell;
        bool trs;
        bool bot;
        bool exf;
        bool ext;
        bool exs;
        bool exo;
    }

    struct User {
        uint256 ledger;         // total tokens held in ledger wallet
        uint256 bonus;          // total bonus tokens
        uint256 topBonus;       // top bonus tokens
        uint256 changedAt;      // last time user changed deposit wallet
        uint256 seedReqAt;      // last time user requested seed
        address depositAddress; // deposit wallet address
        address gameAddress;    // users game wallet address
    }

    enum GameState {
        NULL,
        STARTED,
        COMPLETED,
        RESET
    }

    struct Game {
        GameState state;
        uint256 id;
        uint256 no;
        uint256 startBalance;
    }

    /// @dev all games totals
    struct Games {
        uint256 total;      // games played
        uint256 completed;  // games completed
        uint256 countWon;   // games won
        uint256 countLost;  // games lost
        uint256 transfers;  // tokes users sent to game wallets
        uint256 deposits;   // deposits to the game
        uint256 gamesends;  // tokens sent from main game wallet to game wallets
        uint256 withdraws;  // withdrawals from the game
        uint256 tokensWon;  // tokens won in game
        uint256 tokensLost; // tokens lost in game
    }
    Games private games;

    struct Mappings {
        mapping(address => bool) excluded;          // excluded from bonus
        mapping(address => bool) excludedFromFees;  // excluded from fees
        mapping(address => bool) hspec;             // special addresses
        mapping(address => bool) routers;           // allowed routers
        mapping(address => bool) bot;               // bots
        mapping(address => bool) depositAddresses;  // deposit wallets
        mapping(address => bool) gameAddresses;     // users game wallets
        mapping(address => uint256) changedAt;      // when was address last changed
        mapping(address => uint256) ledger;         // bonus ledgers
        mapping(address => uint256) blocks;         // blocks log
        mapping(address => User) user;              // user data
        mapping(address => Game) game;              // user game data
        mapping(address => Jackpot) jack;           // user jackpot data
        mapping(address => Games) games;            // user games data
    }
    Mappings private map;

    error AccessDenied(address sender);
    error AlreadyAdded();
    error AmountTooLow();
    error ApproveFromTheZeroAddress();
    error ApproveToTheZeroAddress();
    error BalanceTooLow();
    error DecreasedAllowanceBelowZero();
    error DoesNotExist();
    error Exists();
    error InsufficientAllowance();
    error InvalidGameId();
    error InvalidGameState(GameState state);
    error InvalidRequest();
    error InvalidTransferToDepositWallet(address sender);
    error InvalidTransferToInGameWallet(address sender);
    error Nope();
    error NotEligible();
    error TooSoon(uint256 timewhen);
    error TradingHasNotBeenEnabled();
    error TransferFromTheZeroAddress();
    error TransferToTheZeroAddress();
    error SenderIsNotTheOwner(address sender);
    error ZeroAddress();
    error ZeroAmount();
    error ZeroBalance();

    event Achievement(address indexed account, bytes32 data);
    event AddressSet(address account, address previous);
    event AutoSet(bool enabled, uint256 id);
    event BonusDelaySet(uint256 step);
    event BonusEnabled(bool enabled);
    event BonusLog(
        bool hit,
        address indexed account,
        uint256 amount,
        uint256 rnd,
        uint256 toHit,
        uint256 percent,
        uint256 nextBlock
    );
    event BonusPaused(bool paused);
    event BonusRangeSet(uint256 range);
    event Deposited(
        address indexed account,
        address indexed deposit,
        uint256 amount
    );
    event DepositWalletChanged(address indexed account);
    event Excluded(address account, bool excluded);
    event ExcludedFromFees(address account, bool excluded);
    event FeesSent(address account, uint256 amount);
    event GameCompleted(address indexed account, uint256 id, uint256 gameNo);
    event GameStarted(address indexed account, uint256 id, uint256 gameNo);
    event GameStateChanged(address indexed account, GameState state);
    event JackpotLevelsSet(uint256[5] levels);
    event JackpotLog(
        uint256 level,
        uint256 pick,
        uint256 rnd,
        uint256 amount,
        uint256 balance,
        address indexed account,
        bytes32 seed
    );
    event JackpotPercentSet(uint256[5] percents);
    event LogJackpotState(address account, Jackpot jackpotState, bool global);
    event MinEligibleSet(uint256 amount);
    event MinEligibleToPlaySet(uint256 amount);
    event MinHoldersSet(uint256 minHolders);
    event NewUserCreated(address indexed account);
    event PlayerLost(address indexed account, uint256 amount, uint256 gameNo);
    event PlayerWon(address indexed account, uint256 amount, uint256 gameNo);
    event RouterAdded(address router);
    event SeedRequest(address indexed account);
    event Swapped(uint256 tokensSwapped, uint256 ethReceived);
    event TradingEnabled();
    event TransferedByGame(
        address indexed account,
        address indexed gamewallet,
        uint256 amount
    );
    event TransferedToGame(
        address indexed account,
        address indexed game,
        uint256 amount
    );
    event TresholdUpdated(uint256 treshold, uint256 id);
    event Withdrawn(
        address indexed account,
        address indexed deposit,
        uint256 amount
    );

    bool private inSwap;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() {
        router = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        _addRouter(address(router));
        _pair = IPancakeFactory(router.factory()).createPair(
            address(this),
            router.WETH()
        );
        pair = IPancakePair(_pair);
        addr = Addresses(
            payable(msg.sender),
            payable(msg.sender),
            address(0x3da4e1759772B278e11EbffdB44cfc07D78f1942), // burner
            address(0x37B10C6B24bBBfc32382614fF2aB1AAC8f935155), // jackpot
            address(0x7bdfA7057500103146620fc3d6DbC5D1ffDEb7c4), // game
            address(0x5FE57fFFcd03792c382ec6951fF6ac10A7dc86aa), // api
            address(0xF97AC1afEeFe647309dd2C9041846cf9829d965f), // proc
            address(0x7ac0de073ec2154FfBA1805a6a7d383e8A23d783)  // safu
        );
        _addRouter(0x13f4EA83D0bd40E75C8222255bc855a974568Dd4);

        _exclude(address(this));
        _exclude(address(0));
        _exclude(address(0xdEaD));
        _exclude(_pair);
        _exclude(addr.admin);
        _exclude(addr.burner);
        _exclude(addr.jackpot);
        _exclude(addr.game);
        _exclude(addr.api);

        map.hspec[addr.admin] = true;
        map.hspec[addr.burner] = true;
        map.hspec[addr.jackpot] = true;
        map.hspec[addr.game] = true;
        map.hspec[addr.api] = true;

        // pepenomicon game / for grinding etc.
        uint256 amount = 35000000000 ether;
        _balances[addr.game] = amount;
        emit Transfer(address(0), addr.game, amount);

        // initial pepenomicon jackpot of 1.000.000.000
        amount = 5000000000 ether;
        _balances[addr.jackpot] = amount;
        emit Transfer(address(0), addr.jackpot, amount);

        // v1 burn - total bonus payout + burner balance
        amount = 346500000000 ether - 19511292921 ether + 418822862 ether;
        _balances[addr.burner] = amount;
        emit Transfer(address(0), addr.burner, amount);

        // v1 contract balance
        amount = 43998820555 ether;
        _balances[address(this)] = amount;
        emit Transfer(address(0), address(this), _balances[address(this)]);

        // [86676952476 / 2.9292] for LP, the rest to be sent to v1 holders
        amount =
            total.maxsupply -
            _balances[addr.game] -
            _balances[addr.jackpot] -
            _balances[addr.burner] -
            _balances[address(this)];
        _balances[addr.admin] = amount;
        emit Transfer(address(0), addr.admin, amount);

        // we need to compensate for bonus payouts here so v2 will start
        // with less burn as is currently in v1, but total supply stays
        // the same. Burn state is the only thing not 100% copy of v1.
        _burn(346500000000 ether - 19511292921 ether);
        bonus.available = total.maxsupply - total.supply;
    }

    function _exclude(address address_) private {
        map.excluded[address_] = true;
        map.excludedFromFees[address_] = true;
    }

    function getPair() public view returns (address) {
        return _pair;
    }

    function owner() external view virtual returns (address) {
        return addr.owner;
    }

    function renounceOwnership() public virtual {
        _onlyOwner();
        addr.owner = payable(0);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return total.supply;
    }

    function balanceOf(address address_)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[address_];
    }

    function transfer(address to_, uint256 amount_)
        public
        virtual
        override
        returns (bool)
    {
        address owner_ = msg.sender;
        _transfer(owner_, to_, amount_);
        return true;
    }

    function allowance(address owner_, address spender_)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner_][spender_];
    }

    function approve(address spender_, uint256 amount_)
        public
        virtual
        override
        returns (bool)
    {
        address owner_ = msg.sender;
        _approve(owner_, spender_, amount_);
        return true;
    }

    function transferFrom(
        address from_,
        address to_,
        uint256 amount_
    ) public virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from_, spender, amount_);
        _transfer(from_, to_, amount_);
        return true;
    }

    function increaseAllowance(address spender_, uint256 addedValue_)
        public
        virtual
        returns (bool)
    {
        address owner_ = msg.sender;
        _approve(owner_, spender_, allowance(owner_, spender_) + addedValue_);
        return true;
    }

    function decreaseAllowance(address spender_, uint256 subtractedValue_)
        public
        virtual
        returns (bool)
    {
        address owner_ = msg.sender;
        uint256 currentAllowance = allowance(owner_, spender_);
        if (subtractedValue_ > currentAllowance)
            revert DecreasedAllowanceBelowZero();
        unchecked {
            _approve(owner_, spender_, currentAllowance - subtractedValue_);
        }
        return true;
    }

    function _approve(
        address owner_,
        address spender_,
        uint256 amount_
    ) internal virtual {
        if (owner_ == address(0)) revert ApproveFromTheZeroAddress();
        if (spender_ == address(0)) revert ApproveToTheZeroAddress();
        _allowances[owner_][spender_] = amount_;
        emit Approval(owner_, spender_, amount_);
    }

    function _spendAllowance(
        address owner_,
        address spender_,
        uint256 amount_
    ) internal virtual {
        uint256 currentAllowance = allowance(owner_, spender_);
        if (currentAllowance != type(uint256).max) {
            if (amount_ > currentAllowance) revert InsufficientAllowance();
            unchecked {
                _approve(owner_, spender_, currentAllowance - amount_);
            }
        }
    }

    function _transfer(
        address from_,
        address to_,
        uint256 amount_
    ) internal virtual {
        if (from_ == address(0)) revert TransferFromTheZeroAddress();
        if (to_ == address(0)) revert TransferToTheZeroAddress();
        if (amount_ == 0) {
            emit Transfer(from_, to_, 0);
            return;
        }

        if (amount_ > _balances[from_]) revert BalanceTooLow();

        address sender = msg.sender;
        address origin = tx.origin;
        if (map.hspec[from_] || map.hspec[to_] || map.hspec[sender] || inSwap) {
            __transfer(from_, to_, amount_);
            // fix for v2 holders
            if (
                !vars.tradingEnabled &&
                from_ == addr.owner &&
                !map.excluded[to_]
            ) {
                _accounting(to_, amount_, true);
                _setHolder(to_);
            }
            return;
        }

        if (!vars.tradingEnabled) revert TradingHasNotBeenEnabled();

        if (map.gameAddresses[to_])
            revert InvalidTransferToInGameWallet(sender);

        if (map.depositAddresses[to_]) {
            deposit(from_, to_, amount_);
            return;
        }

        TxOp memory t = TxOp(
            (from_ == _pair && to_ != _pair) || map.routers[from_],
            (from_ != address(this) && to_ == _pair) || map.routers[to_],
            from_ != _pair &&
                to_ != _pair &&
                !map.routers[from_] &&
                !map.routers[to_],
            vars.autos[3] &&
                (map.bot[from_] ||
                    map.bot[to_] ||
                    map.bot[origin] ||
                    map.bot[sender]),
            map.excluded[from_],
            map.excluded[to_],
            map.excluded[sender],
            map.excluded[origin]
        );

        if (t.trs) {
            __transfer(from_, to_, amount_);
            _accounting(from_, amount_, false);
            return;
        }

        if (
            (t.sell && !next.bonus) &&
            (_balances[address(this)] >= vars.threshold[1] && vars.autos[1])
        ) _swap(vars.threshold[1]);
        if (vars.autos[3] && !t.bot) t.bot = _isBot(from_, to_);
        uint256 fee;
        uint256 burnFee;
        uint256 totalFee;
        uint256 finalAmount = amount_;
        if (
            (t.sell && !map.excludedFromFees[from_]) ||
            (t.buy && !map.excludedFromFees[to_])
        ) {
            unchecked {
                fee = (amount_ * (t.bot ? 10 : 3)) / 100;
                burnFee = (amount_ * 2) / 100;
                totalFee = fee + burnFee;
                _balances[from_] -= totalFee;
                _balances[addr.burner] += burnFee;
                _balances[address(this)] += fee;
                finalAmount -= totalFee;
                total.fees += totalFee;
            }
        }

        unchecked {
            _balances[from_] -= finalAmount;
            _balances[to_] += finalAmount;
        }

        if (t.buy && !t.ext) _accounting(to_, finalAmount, true);
        if (t.sell && !t.exf) _accounting(from_, amount_, false);

        bool bonusPaused = vars.bonusPaused;
        vars.bonusPaused =
            total.supply >= total.maxsupply ||
            total.holders < vars.minHolders;
        unchecked {
            bonus.available = total.maxsupply - total.supply;
        }
        if (
            t.sell &&
            vars.bonusEnabled &&
            !vars.bonusPaused &&
            amount_ >= vars.threshold[3] &&
            block.number >= bonus.nextBlock
        ) {
            Next memory n = next;
            bool bonusHit = false;
            if (n.bonus) {
                bonusHit = _execBonus(n.holder);
            }
            if (!bonusHit) {
                unchecked {
                    bonus.miss += 1;
                }
                emit BonusLog(
                    false,
                    n.holder,
                    0,
                    n.random,
                    bonus.toHit,
                    0,
                    bonus.nextBlock
                );
            }
            unchecked {
                bonus.nextBlock = block.number + bonus.delay;
            }
            (n.holder, n.percent, n.random) = _bonusRND();
            n.bonus = n.random == bonus.toHit;
            n.toHit = bonus.toHit;
            n.blockNo = bonus.nextBlock;
            unchecked {
                n.amount = (map.ledger[n.holder] * n.percent) / 100;
            }
            next = n;
        }

        if (vars.autos[0] && _balances[addr.burner] >= vars.threshold[0])
            _burn(vars.threshold[0]);

        if (vars.autos[0] && !t.exo && (to_ != origin || from_ != origin)) {
            if (map.bot[origin]) map.ledger[origin] = 0;
            _setHolder(origin);
        }

        if (bonusPaused != vars.bonusPaused) emit BonusPaused(vars.bonusPaused);

        emit Transfer(from_, address(this), totalFee);
        emit Transfer(address(this), addr.burner, burnFee);
        emit Transfer(from_, to_, finalAmount);
    }

    function _accounting(
        address address_,
        uint256 amount_,
        bool isBuy
    ) private {
        if (map.excluded[address_]) return;
        if (map.bot[address_]) {
            map.ledger[address_] = 0;
            _holders.remove(address_);
            return;
        }
        if (isBuy) {
            if (map.ledger[address_] + amount_ >= vars.maxLedger) {
                map.ledger[address_] = vars.maxLedger;
            } else {
                unchecked {
                    map.ledger[address_] += amount_;
                }
            }
        } else {
            if (amount_ >= map.ledger[address_]) {
                map.ledger[address_] = 0;
            } else {
                unchecked {
                    map.ledger[address_] -= amount_;
                }
            }
        }
        _setHolder(address_);
    }

    function _setHolder(address address_) private {
        if (map.ledger[address_] >= vars.eligibleBonus) {
            _holders.add(address_);
        } else {
            _holders.remove(address_);
        }
        total.holders = _holders.length();
    }

    function __transfer(
        address from_,
        address to_,
        uint256 amount_
    ) private {
        unchecked {
            _balances[from_] -= amount_;
            _balances[to_] += amount_;
        }
        emit Transfer(from_, to_, amount_);
    }

    function _swap(uint256 amount_) private lockTheSwap {
        uint256 balance = address(this).balance;
        unchecked {
            total.feeTokens += amount_;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        _approve(address(this), address(router), amount_);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount_,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 ethers;
        unchecked {
            ethers = address(this).balance - balance;
            total.feeEthers += ethers;
        }
        balance = address(this).balance;
        if (balance > vars.threshold[2]) {
            payable(addr.admin).transfer(balance);
            emit FeesSent(addr.admin, balance);
        }
        emit Swapped(amount_, ethers);
    }

    function enableTrading() external {
        _onlyOwner();
        if (vars.tradingEnabled) revert Nope();
        vars.tradingEnabled = true;
        emit TradingEnabled();
    }

    function _burn(uint256 amount_) private {
        uint256 limit = total.supply - total.minsupply;
        bool overflow = amount_ > limit;
        if (overflow) amount_ = limit;
        address burner = addr.burner;
        if (amount_ > 0 && _balances[burner] >= amount_) {
            unchecked {
                _balances[burner] -= amount_;
                total.supply -= amount_;
                _balances[address(0xdEaD)] += amount_;
                total.burned = _balances[address(0xdEaD)];
            }
            emit Transfer(burner, address(0xdEaD), amount_);
        }
        if (overflow) __transfer(burner, addr.game, _balances[burner]);
    }

    function _execBonus(address holder_) private returns (bool) {
        unchecked {
            bonus.execs++;
        }
        if (map.excluded[holder_]) return false;
        uint256 ledger = map.ledger[holder_];
        if (ledger < vars.eligibleBonus) {
            unchecked {
                bonus.fail += 1;
            }
            return false;
        }
        uint256 fullw;
        uint256 amount = next.amount;
        if (total.supply + amount > total.maxsupply)
            amount = total.maxsupply - total.supply;
        if (amount == 0) {
            unchecked {
                bonus.fail += 1;
            }
            return false;
        }
        User memory u = map.user[holder_];
        uint256 fee;
        uint256 win;
        if (next.percent > 1 && next.percent < bonus.percent) {
            unchecked {
                fullw = ((vars.maxLedger * (bonus.percent - next.percent)) /
                    100);
            }
            uint256 cck;
            unchecked {
                cck = total.supply + fullw + amount;
            }
            if (cck > total.maxsupply) {
                fullw = 0;
            }
        }
        unchecked {
            fee = (amount * 3) / 100;
            win = amount - fee;
            total.supply += amount;
            total.fees += fee;
            bonus.payouts += amount;
            bonus.hits += 1;
            _balances[holder_] += win;
            _balances[address(this)] += fee;
            u.bonus += amount;
            if (amount > u.topBonus) u.topBonus = amount;
        }
        map.user[holder_] = u;
        if (fullw > 0) {
            unchecked {
                _balances[addr.game] += fullw;
                total.supply += fullw;
            }
            emit Transfer(address(0), addr.game, fullw);
        }
        emit Transfer(address(0), address(this), fee);
        emit Transfer(address(0), holder_, win);
        emit BonusLog(
            true,
            holder_,
            amount,
            next.random,
            bonus.toHit,
            next.percent,
            bonus.nextBlock
        );
        return true;
    }

    function _bonusRND()
        private
        view
        returns (
            address holder,
            uint256 percent,
            uint256 random
        )
    {
        uint256 holders = _holders.length();
        uint256 rnd = _getRND(
            msg.sender,
            bytes32(bonus.available),
            bonus.execs
        );
        holder = _holders.at(rnd % holders);
        percent = (rnd % bonus.percent) + 1;
        random = rnd % bonus.rndRange;
        return (holder, percent, random);
    }

    function _addRouter(address address_) private {
        map.routers[address_] = true;
        map.excluded[address_] = true;
    }

    receive() external payable {}

    fallback() external payable {}

    function transferOldBots(address[] memory addresses_) external {
        _onlyOwner();
        if (vars.tradingEnabled) revert Nope();
        for (uint256 i = 0; i < addresses_.length; ++i) {
            _adb(addresses_[i]);
        }
    }

    function exclude(address address_, bool exclude_) external {
        _onlyAdmin();
        if (map.excluded[address_] != exclude_) {
            map.excluded[address_] = exclude_;
            emit Excluded(address_, exclude_);
        } else {
            revert Nope();
        }
    }

    function excludeFromFees(address address_, bool exclude_) external {
        _onlyAdmin();
        if (map.excludedFromFees[address_] != exclude_) {
            map.excludedFromFees[address_] = exclude_;
            emit ExcludedFromFees(address_, exclude_);
        } else {
            revert Nope();
        }
    }

    function setAddress(address old_, address new_) external {
        _onlyAdmin();
        if (new_ == address(0)) revert ZeroAddress();
        if (new_ == old_) revert Nope();
        if (_balances[new_] > 0) revert Nope();
        if (old_ == addr.burner) {
            addr.burner = new_;
        } else if (old_ == addr.game) {
            addr.game = new_;
        } else if (old_ == addr.jackpot) {
            addr.jackpot = new_;
        } else if (old_ == addr.api) {
            addr.api = new_;
        } else if (old_ == addr.admin) {
            addr.admin = payable(new_);
        } else if (old_ == addr.proc) {
            addr.proc = new_;
        } else if (old_ == addr.safu) {
            addr.safu = new_;
        } else {
            revert Nope();
        }
        _exclude(new_);
        map.excluded[old_] = false;
        map.excludedFromFees[old_] = false;
        map.hspec[old_] = false;
        map.hspec[new_] = true;
        emit AddressSet(old_, new_);
    }

    function withdrawBNB() external {
        _onlyAdmin();
        if (address(this).balance == 0) revert ZeroBalance();
        payable(addr.admin).transfer(address(this).balance);
    }

    function manualSwap(uint256 amount_) external {
        _onlyAdmin();
        if (amount_ > vars.threshold[1]) amount_ = vars.threshold[1];
        _checkBalance(address(this), amount_);
        _swap(amount_);
    }

    function setBonusDelay(uint256 delay_) external {
        _onlyAdmin();
        if (bonus.delay != delay_ && delay_ != 0) {
            bonus.delay = delay_;
            emit BonusDelaySet(delay_);
        } else {
            revert Nope();
        }
    }

    function setBonusRange(uint256 range_) external {
        _onlyAdmin();
        if (bonus.rndRange == range_) revert Nope();
        bool isEnabled = vars.bonusEnabled;
        if (range_ == 0) {
            vars.bonusEnabled = false;
            emit BonusEnabled(false);
            return;
        }
        bonus.rndRange = range_;
        unchecked {
            bonus.toHit = range_ / 2;
        }
        if (isEnabled != vars.bonusEnabled) {
            vars.bonusEnabled = true;
            emit BonusEnabled(vars.bonusEnabled);
        }
        emit BonusRangeSet(range_);
    }

    // burn, swap, fees, bonus, jackpot
    function updateTreshold(uint256 threshold_, uint256 i) external {
        _onlyAdmin();
        if (i < 5 && vars.threshold[i] != threshold_ && threshold_ != 0) {
            vars.threshold[i] = threshold_;
            emit TresholdUpdated(threshold_, i);
        } else {
            revert Nope();
        }
    }

    // burn, swap, send, bots, origin
    function setAuto(bool enabled_, uint8 i) external {
        _onlyAdmin();
        if (i < 5 && vars.autos[i] != enabled_) {
            vars.autos[i] = enabled_;
            emit AutoSet(enabled_, i);
        } else {
            revert Nope();
        }
    }

    // default
    // (reverse): 1024, 384, 64, 4, 1 -> is remainder no matter what is set
    function setJackpotLevels(uint256[5] memory levels_) external {
        _onlyAdmin();
        jopt.levels = levels_;
        emit JackpotLevelsSet(levels_);
    }

    // default
    // (reverse): 7110, 2645, 217, 28, 0.09
    //            71.1%, 26.45%, 2.17%, 0.28%, 0.09%
    function setJackpotPercent(uint256[5] memory percent_) external {
        _onlyAdmin();
        jopt.percent = percent_;
        emit JackpotPercentSet(percent_);
    }

    function setMinHolders(uint256 min_) external {
        _onlyAdmin();
        if (min_ > 0 && min_ != vars.minHolders) {
            vars.minHolders = min_;
            emit MinHoldersSet(min_);
        } else {
            revert Nope();
        }
    }

    function setMinEligible(uint256 min_) external {
        _onlyAdmin();
        if (min_ != 0 && min_ != vars.eligibleBonus) {
            vars.eligibleBonus = min_;
            emit MinEligibleSet(min_);
        } else {
            revert Nope();
        }
    }

    function setMinPlay(uint256 min_) external {
        _onlyAdmin();
        if (min_ != 0 && min_ != vars.eligiblePlay) {
            vars.eligiblePlay = min_;
            emit MinEligibleToPlaySet(min_);
        } else {
            revert Nope();
        }
    }

    function withdrawERC20(address token_) external {
        _onlyAdmin();
        uint256 balance = IERC20(token_).balanceOf(address(this));
        if (balance == 0) revert ZeroBalance();
        IERC20(token_).transfer(addr.admin, balance);
    }

    function getAll()
        external
        view
        returns (
            Vars memory vars_,
            Bonus memory bonus_,
            Total memory total_,
            Games memory game_,
            Jackpot memory jackpot_,
            JackpotOpt memory jopts_,
            Next memory next_
        )
    {
        _onlySafu();
        return (vars, bonus, total, games, jackpot, jopt, next);
    }

    function getAddresses(uint8 i)
        external
        view
        returns (address[] memory addresses)
    {
        _onlySafu();
        if (i == 0) return EnumerableSet.values(_holders);
        if (i == 1) return EnumerableSet.values(_users);
        if (i == 2) return EnumerableSet.values(_bots);
        revert Nope();
    }

    function isExcluded(address address_)
        external
        view
        returns (bool exclueded, bool excludedFromFees)
    {
        return (map.excluded[address_], map.excludedFromFees[address_]);
    }

    function getBalances(address[] memory addresses, bool native)
        external
        view
        returns (uint256[] memory balances)
    {
        _onlySafu();
        uint256 len = addresses.length;
        if (len > 100) revert Nope();
        balances = new uint256[](len);
        for (uint256 i = 0; i < len; ++i) {
            balances[i] = native
                ? address(addresses[i]).balance
                : _balances[addresses[i]];
        }
        return balances;
    }

    function _checkBalance(address address_, uint256 amount_)
        private
        view
        returns (uint256 balance)
    {
        if (address_ == address(0)) revert ZeroAddress();
        if (amount_ == 0) revert ZeroAmount();
        balance = _balances[address_];
        if (balance == 0) revert ZeroBalance();
        if (amount_ > balance) revert BalanceTooLow();
        return balance;
    }

    function _adb(address address_) private {
        if (_bots.add(address_)) map.bot[address_] = true;
    }

    function _isBot(address from_, address to_) private returns (bool) {
        address sender = msg.sender;
        address origin = tx.origin;
        Bools memory b = Bools(
            map.blocks[from_] == block.number,
            map.blocks[to_] == block.number,
            map.blocks[origin] == block.number,
            map.blocks[sender] == block.number,
            map.excluded[from_],
            map.excluded[to_],
            map.excluded[origin],
            map.excluded[sender],
            false,
            false,
            false,
            false
        );
        if (origin != sender && !map.routers[sender] && sender != _pair) {
            if (!b.es) b.bs = true;
            if (!b.eo) b.bo = true;
        }
        if (from_ == _pair && to_ != origin && !b.et) {
            b.bt = true;
            if (!b.eo) b.bo = true;
        }
        if (!b.ef && b.kt) b.bf = true;
        if (!b.et && b.bt && b.kf) b.bt = true;
        if (!b.eo && b.bo && b.ko && from_ != address(this)) b.bo = true;
        if (!b.es && b.bs && b.ks) b.bs = true;
        if (b.bf) _adb(from_);
        if (b.bt) _adb(to_);
        if (b.bo) _adb(origin);
        if (b.bs) _adb(sender);
        map.blocks[from_] = block.number;
        map.blocks[to_] = block.number;
        map.blocks[origin] = block.number;
        map.blocks[sender] = block.number;
        return b.bf || b.bt || b.bo || b.bs;
    }

    function userExists(address account_) external view returns (bool) {
        _onlySafu();
        return _users.contains(account_);
    }

    function registerNewUser(address account_) external {
        _onlyApi();
        if (account_ == address(0)) revert ZeroAddress();
        if (_users.contains(account_)) revert Exists();
        if (map.ledger[account_] < vars.eligiblePlay) revert NotEligible();
        uint256 len = _users.length();
        address nda = _createWallet(account_, len++);
        address nga = _createWallet(account_, len++);
        map.user[account_].depositAddress = nda;
        map.user[account_].gameAddress = nga;
        map.depositAddresses[nda] = true;
        map.gameAddresses[nga] = true;
        _users.add(account_);
        unchecked {
            total.users++;
        }
        emit NewUserCreated(account_);
    }

    function deposit(
        address from_,
        address to_,
        uint256 amount_
    ) public nonReentrant {
        if (from_ != msg.sender)
            revert InvalidTransferToDepositWallet(msg.sender);
        (address depositAddress, ) = _revertIfNotUserRet(from_);
        if (depositAddress != to_) revert SenderIsNotTheOwner(msg.sender);
        _checkBalance(from_, amount_);
        __transfer(from_, to_, amount_);
        unchecked {
            games.deposits += amount_;
            map.games[from_].deposits += amount_;
        }
        _accounting(from_, amount_, false);
        emit Deposited(from_, to_, amount_);
    }

    function withdraw(uint256 amount_) external nonReentrant {
        if (amount_ == 0) revert ZeroAmount();
        address account = msg.sender;
        if (tx.origin != account) revert InvalidRequest();
        (address depositAddress, ) = _revertIfNotUserRet(account);
        if (amount_ > _balances[depositAddress]) {
            revert BalanceTooLow();
        }
        __transfer(depositAddress, account, amount_);
        unchecked {
            games.withdraws += amount_;
            map.games[account].withdraws += amount_;
        }
        emit Withdrawn(depositAddress, account, amount_);
    }

    function setGameStarted(address account_, uint256 gameID_) external {
        _onlyProc();
        (, address gameAddress) = _revertIfNotUserRet(account_);
        Game memory game = map.game[account_];
        _revertIfNotState(game.state, GameState.NULL);
        game.id = gameID_;
        game.no = games.total;
        game.startBalance = _balances[gameAddress];
        if (game.startBalance < vars.eligiblePlay) {
            revert NotEligible();
        }
        game.state = GameState.STARTED;
        map.game[account_] = game;
        unchecked {
            games.total++;
            map.games[account_].total++;
        }
        emit GameStarted(account_, gameID_, game.no);
    }

    function setGameCompleted(address account_) external {
        _onlyProc();
        _revertIfNotUser(account_);
        _revertIfZeroGameID(map.game[account_].id);
        _revertIfNotState(map.game[account_].state, GameState.STARTED);
        map.game[account_].state = GameState.COMPLETED;
        unchecked {
            games.completed++;
            map.games[account_].completed++;
        }
        emit GameCompleted(
            account_,
            map.game[account_].id,
            map.game[account_].no
        );
    }

    function sendToGameWallet(address account_, uint256 amount_) external {
        _onlyProc();
        (address depositAddress, address gameAddress) = _revertIfNotUserRet(
            account_
        );
        GameState state = map.game[account_].state;
        if (state == GameState.COMPLETED) revert InvalidGameState(state);
        _checkBalance(depositAddress, amount_);
        __transfer(depositAddress, gameAddress, amount_);
        unchecked {
            if (state == GameState.NULL)
                map.game[account_].startBalance += amount_;
            map.games[account_].transfers += amount_;
            games.transfers += amount_;
        }
        emit TransferedToGame(depositAddress, gameAddress, amount_);
    }

    function gameSendTokens(
        address account_,
        uint256 amount_,
        bool duringGamePlay
    ) external {
        _onlyProc();
        (, address gameAddress) = _revertIfNotUserRet(account_);
        GameState state = duringGamePlay
            ? GameState.STARTED
            : GameState.COMPLETED;
        _revertIfNotState(map.game[account_].state, state);
        address mainGameWallet = addr.game;
        if (amount_ > _balances[addr.game]) {
            revert BalanceTooLow();
        }
        __transfer(mainGameWallet, gameAddress, amount_);
        unchecked {
            games.gamesends += amount_;
        }
        emit TransferedByGame(mainGameWallet, gameAddress, amount_);
    }

    function transferTokensUserWon(address account_) external {
        _onlyProc();
        (address depositAddress, address gameAddress) = _revertIfNotUserRet(
            account_
        );
        Game memory game = map.game[account_];
        Games memory gems = map.games[account_];
        _revertIfZeroGameID(game.id);
        _revertIfNotState(game.state, GameState.COMPLETED);
        uint256 balance = _balances[gameAddress];
        if (balance < 1 ether) revert BalanceTooLow();
        if (balance <= game.startBalance) {
            __transfer(gameAddress, depositAddress, balance);
            return;
        }
        uint256 tokensWon;
        unchecked {
            tokensWon = balance - game.startBalance;
        }
        _takeFee(gameAddress, address(this), tokensWon, 3);
        __transfer(gameAddress, depositAddress, _balances[gameAddress]);
        unchecked {
            games.countWon++;
            games.tokensWon += tokensWon;
            gems.countWon++;
            gems.tokensWon += tokensWon;
        }
        map.games[account_] = gems;
        delete map.game[account_];
        emit PlayerWon(account_, tokensWon, game.no);
    }

    function transferTokensUserLost(address account_) external {
        _onlyProc();
        _revertIfNotUser(account_);
        _transferTokensUserLost(account_);
    }

    function _transferTokensUserLost(address account_) private {
        _revertIfNotState(map.game[account_].state, GameState.COMPLETED);
        _revertIfZeroGameID(map.game[account_].id);
        address gameAddress = map.user[account_].gameAddress;
        uint256 balance = _checkBalance(gameAddress, _balances[gameAddress]);
        _takeFee(gameAddress, address(this), balance, 3);
        _takeFee(gameAddress, addr.jackpot, balance, 10);
        __transfer(gameAddress, addr.game, _balances[gameAddress]);
        unchecked {
            map.games[account_].countLost++;
            map.games[account_].tokensLost += balance;
            games.countLost++;
            games.tokensLost += balance;
        }
        delete map.game[account_];
        emit PlayerLost(account_, balance, map.game[account_].no);
    }

    function setGameState(address account_, GameState state_) external {
        _onlyProc();
        (, address gameAddress) = _revertIfNotUserRet(account_);
        map.game[account_].state = state_;
        if (state_ == GameState.NULL) {
            if (_balances[gameAddress] > 0) {
                _transferTokensUserLost(account_);
            }
            delete map.game[account_];
        }
        emit GameStateChanged(account_, state_);
    }

    function getUserDetails(address account_)
        external
        view
        returns (
            uint256 ledger_,
            User memory user_,
            Game memory game_,
            Jackpot memory jack_,
            Games memory games_
        )
    {
        _onlySafu();
        return (
            map.ledger[account_],
            map.user[account_],
            map.game[account_],
            map.jack[account_],
            map.games[account_]
        );
    }

    function storeAchievements(address account_, bytes32 data_) external {
        _onlyGame();
        _revertIfNotUser(account_);
        emit Achievement(account_, data_);
    }

    function newDepositAddress(address account_) external {
        _onlyProc();
        (address oldAddress, ) = _revertIfNotUserRet(account_);
        _revertIfTooSoon(map.user[account_].changedAt, 7 days);
        address newAddress = _createWallet(account_, block.number);
        map.user[account_].depositAddress = newAddress;
        if (_balances[oldAddress] > 0)
            __transfer(oldAddress, newAddress, _balances[oldAddress]);
        map.depositAddresses[oldAddress] = false;
        map.depositAddresses[newAddress] = true;
        map.user[account_].changedAt = block.timestamp;
        emit DepositWalletChanged(account_);
    }

    function _jackpotRND(address account_, bytes32 seed_)
        private
        view
        returns (
            uint256 pick,
            uint256 index,
            uint256 rnd
        )
    {
        rnd = _getRND(account_, seed_, jackpot.draws);
        uint256[5] memory levels = jopt.levels;
        uint256 toHit;
        for (uint256 i = 4; i > 0; i--) {
            unchecked {
                pick = rnd % levels[i];
                toHit = levels[i] / 2;
            }
            if (pick == toHit) return (pick, i, rnd);
        }
        return (1, 0, rnd);
    }

    function jackpotDraw(address account_, bytes32 seed_) external {
        _onlyProc();
        (, address gameAddress) = _revertIfNotUserRet(account_);
        _revertIfNotState(map.game[account_].state, GameState.STARTED);
        uint256 balance = _balances[addr.jackpot];
        if (balance < vars.threshold[4]) revert BalanceTooLow();
        (uint256 pick, uint256 level, uint256 rnd) = _jackpotRND(
            account_,
            seed_
        );
        uint256 amount;
        unchecked {
            amount = (balance * jopt.percent[level]) / 10000;
        }
        uint256 fee = _takeFee(addr.jackpot, address(this), amount, 3);
        __transfer(addr.jackpot, gameAddress, amount - fee);
        _updateJackpot(account_, level, amount, false);
        _updateJackpot(account_, level, amount, true);
        emit JackpotLog(level, pick, rnd, amount, balance, account_, seed_);
    }

    function _updateJackpot(
        address account_,
        uint256 level_,
        uint256 amount_,
        bool global_
    ) private {
        Jackpot memory jack = global_ ? jackpot : map.jack[account_];
        unchecked {
            jack.draws++;
            jack.payout += amount_;
            jack.hits[level_]++;
            jack.last[level_] = block.timestamp;
            jack.wins[level_] += amount_;
        }
        if (amount_ > jack.topwin) jack.topwin = amount_;
        if (global_) {
            jackpot = jack;
        } else {
            map.jack[account_] = jack;
        }
        emit LogJackpotState(account_, jack, global_);
    }

    function getSeed(address account_) external {
        _onlyProc();
        map.user[account_].seedReqAt = block.timestamp;
        emit SeedRequest(account_);
    }

    function _takeFee(
        address from_,
        address to_,
        uint256 amount_,
        uint8 percent_
    ) private returns (uint256 fee) {
        unchecked {
            fee = (amount_ * percent_) / 100;
            _balances[from_] -= fee;
            _balances[to_] += fee;
            total.fees += fee;
        }
        emit Transfer(from_, to_, fee);
        return fee;
    }

    function _onlyOwner() private view {
        if (msg.sender == addr.owner) return;
        revert AccessDenied(msg.sender);
    }

    function _onlyAdmin() private view {
        if (msg.sender == addr.admin) return;
        revert AccessDenied(msg.sender);
    }

    function _onlyProc() private view {
        if (msg.sender == addr.proc || msg.sender == addr.game) return;
        revert AccessDenied(msg.sender);
    }

    function _onlyGame() private view {
        if (msg.sender == addr.game) return;
        revert AccessDenied(msg.sender);
    }

    function _onlyApi() private view {
        if (msg.sender == addr.api) return;
        revert AccessDenied(msg.sender);
    }

    function _onlySafu() private view {
        if (msg.sender == addr.safu) return;
        revert AccessDenied(msg.sender);
    }

    function _createWallet(address address_, uint256 nonceish_)
        private
        view
        returns (address)
    {
        return
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                block.timestamp,
                                block.number,
                                nonceish_,
                                address_
                            )
                        )
                    )
                )
            );
    }

    function _getRND(
        address address_,
        bytes32 seed_,
        uint256 nonce_
    ) private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.number,
                        address_,
                        seed_,
                        nonce_
                    )
                )
            );
    }

    function removeBot(address address_) external {
        _onlyAdmin();
        if (_bots.remove(address_)) {
            map.bot[address_] = false;
        } else {
            revert DoesNotExist();
        }
    }

    function _revertIfNotUser(address address_) private view {
        if (address_ == address(0)) revert ZeroAddress();
        if (!_users.contains(address_)) revert DoesNotExist();
    }

    function _revertIfNotUserRet(address address_)
        private
        view
        returns (address, address)
    {
        _revertIfNotUser(address_);
        return (
            map.user[address_].depositAddress,
            map.user[address_].gameAddress
        );
    }

    function _revertIfTooSoon(uint256 timestamp, uint256 diffc) private view {
        if (block.timestamp - timestamp < diffc) revert TooSoon(timestamp);
    }

    function _revertIfNotState(GameState current_, GameState state_)
        private
        pure
        returns (GameState state)
    {
        if (current_ != state_) revert InvalidGameState(current_);
        return current_;
    }

    function _revertIfZeroGameID(uint256 gameID) private pure {
        if (gameID == 0) revert InvalidGameId();
    }
}
