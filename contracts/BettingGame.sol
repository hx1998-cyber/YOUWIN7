// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BettingGame is ReentrancyGuard, Ownable {
    // 支持的代币列表
    mapping(address => bool) public supportedTokens;
    
    // 每个代币的下注金额
    mapping(address => uint256) public tokenBetAmounts;
    
    // 国库地址
    address public treasuryAddress;
    
    // 游戏参数
    uint256 public constant PLAYERS_REQUIRED = 10;
    
    // 每个代币的游戏记录
    mapping(address => mapping(uint256 => Game)) public games;
    mapping(address => uint256) public tokenRounds;
    
    // 游戏结构
    struct Game {
        address[] players;
        bool isComplete;
        address winner;
    }
    
    // 玩家下注状态
    mapping(address => mapping(uint256 => mapping(address => bool))) public hasBetInRound;
    
    // 游戏状态
    bool public paused = false;
    
    // 事件
    event TokenAdded(address token, uint256 betAmount);
    event TokenRemoved(address token);
    event BetPlaced(address token, address player, uint256 round);
    event WinnerSelected(address token, address winner, uint256 prize);
    
    constructor(address _treasuryAddress) Ownable(msg.sender) {
        require(_treasuryAddress != address(0), "Invalid treasury address");
        treasuryAddress = _treasuryAddress;
    }
    
    // 添加支持的代币
    function addToken(address _token, uint256 _betAmount) external onlyOwner {
        require(_token != address(0), "Invalid token address");
        require(_betAmount > 0, "Bet amount must be greater than 0");
        supportedTokens[_token] = true;
        tokenBetAmounts[_token] = _betAmount;
        tokenRounds[_token] = 1;
        emit TokenAdded(_token, _betAmount);
    }
    
    // 移除支持的代币
    function removeToken(address _token) external onlyOwner {
        require(supportedTokens[_token], "Token not supported");
        delete supportedTokens[_token];
        delete tokenBetAmounts[_token];
        emit TokenRemoved(_token);
    }
    
    // 下注功能
    function placeBet(address _token) external nonReentrant {
        require(!paused, "Game is paused");
        require(supportedTokens[_token], "Token not supported");
        uint256 currentRound = tokenRounds[_token];
        require(!hasBetInRound[_token][currentRound][msg.sender], "Already bet in this round");
        
        uint256 betAmount = tokenBetAmounts[_token];
        require(IERC20(_token).transferFrom(msg.sender, address(this), betAmount), "Transfer failed");
        
        hasBetInRound[_token][currentRound][msg.sender] = true;
        games[_token][currentRound].players.push(msg.sender);
        
        emit BetPlaced(_token, msg.sender, currentRound);
        
        if (games[_token][currentRound].players.length == PLAYERS_REQUIRED) {
            selectWinner(_token);
        }
    }
    
    // 选择赢家
    function selectWinner(address _token) private {
        uint256 currentRound = tokenRounds[_token];
        Game storage game = games[_token][currentRound];
        require(game.players.length == PLAYERS_REQUIRED, "Not enough players");
        require(!game.isComplete, "Game already completed");
        
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.number,
            msg.sender
        ))) % PLAYERS_REQUIRED;
        
        address winner = game.players[randomIndex];
        uint256 betAmount = tokenBetAmounts[_token];
        uint256 totalPrize = betAmount * PLAYERS_REQUIRED;
        uint256 winnerPrize = (totalPrize * 70) / 100;
        uint256 treasuryAmount = totalPrize - winnerPrize;
        
        // 直接转账
        require(IERC20(_token).transfer(winner, winnerPrize), "Winner transfer failed");
        require(IERC20(_token).transfer(treasuryAddress, treasuryAmount), "Treasury transfer failed");
        
        game.isComplete = true;
        game.winner = winner;
        
        emit WinnerSelected(_token, winner, winnerPrize);
        tokenRounds[_token]++;
    }
    
    // 管理功能
    function setTreasuryAddress(address _newTreasuryAddress) external onlyOwner {
        require(_newTreasuryAddress != address(0), "Invalid treasury address");
        treasuryAddress = _newTreasuryAddress;
    }
    
    function pauseGame() external onlyOwner {
        paused = true;
    }
    
    function unpauseGame() external onlyOwner {
        paused = false;
    }
    
    // 查询功能
    function getCurrentPlayers(address _token) external view returns (address[] memory) {
        return games[_token][tokenRounds[_token]].players;
    }
    
    function getGameState(address _token) external view returns (
        uint256 currentRound,
        uint256 playersCount,
        bool isPaused,
        uint256 betAmount
    ) {
        uint256 round = tokenRounds[_token];
        return (
            round,
            games[_token][round].players.length,
            paused,
            tokenBetAmounts[_token]
        );
    }
}
