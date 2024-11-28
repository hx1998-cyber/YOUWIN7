# YOUWIN7
 Multi-token betting game smart contract---meme in pump names YWN7
# YOUWIN7

## 项目简介
YOUWIN7 是一个基于以太坊的多代币投注游戏智能合约。该合约支持多种 ERC20 代币作为投注货币，实现自动开奖和奖池分配功能。

## 项目简介 (English)
YOUWIN7 is a multi-token betting game smart contract based on Ethereum. This contract supports multiple ERC20 tokens as betting currencies, implementing automatic prize distribution and winner selection.

## 主要功能
- 支持多种 ERC20 代币投注
- 10人成团自动开奖
- 70%奖池分配给赢家
- 30%奖池进入国库
- 支持暂停/恢复游戏

## Key Features
- Supports multiple ERC20 tokens for betting
- Automatic winner selection when 10 players join
- 70% of the prize pool goes to the winner
- 30% of the prize pool goes to the treasury
- Supports pausing and resuming the game

## 安装和部署
1. 克隆仓库
   ```bash
   git clone https://github.com/hx1998-cyber/YOUWIN7.git
   cd YOUWIN7
   ```

2. 安装依赖
   ```bash
   npm install
   ```

3. 配置环境变量
   创建 `.env` 文件并添加：
   ```plaintext
   PRIVATE_KEY=你的私钥
   SEPOLIA_URL=你的 Sepolia RPC URL
   ETHERSCAN_API_KEY=你的 Etherscan API key
   ```

4. 编译合约
   ```bash
   npx hardhat compile
   ```

5. 运行测试
   ```bash
   npx hardhat test
   ```

6. 部署合约
   ```bash
   npx hardhat run scripts/deploy.js --network sepolia
   ```

## 合约地址
- Sepolia 测试网：[合约地址]
- 以太坊主网：[合约地址]

## 安全性
- 使用 OpenZeppelin 标准库
- 包含重入攻击防护
- 管理员权限控制

## License
MIT
