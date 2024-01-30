import {HardhatRuntimeEnvironment} from 'hardhat/types';
import {DeployFunction} from 'hardhat-deploy/types';
import {ethers} from 'hardhat';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  // code here
  const {deploy} = hre.deployments; //hre = hardhat runtime enviorment
  const {deployer} = await hre.getNamedAccounts();

  // Constants for deployment
  const VALUE_LOCKED = hre.ethers.parseEther("0.01");
  const UNLOCK_TIME = 10000;

  // Use ethers to get timestamp information
  const blockNumber = await ethers.provider.getBlockNumber();
  const lastBlockTimestamp = (await ethers.provider.getBlock(blockNumber))?.timestamp as number;

  await deploy("Lock", { // Contract name
    from: deployer,
    args: [lastBlockTimestamp + UNLOCK_TIME],
    value: VALUE_LOCKED.toString()
  })

};
export default func;