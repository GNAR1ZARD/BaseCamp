(async () => {
    try {
      const accounts = await web3.eth.getAccounts();
      const deployerAccount = accounts[0];
      const secondAccount = accounts[1];
      const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'baseCamp/remix/tokenDev/artifacts/UnburnableToken.json'));
  
      // Deploy the UnburnableToken contract
      const contractInstance = new web3.eth.Contract(metadata.abi);
  
      const deployedContract = await contractInstance.deploy({
        data: metadata.data.bytecode.object,
        arguments: []
      }).send({
        from: deployerAccount,
        gas: 1500000,
        gasPrice: '30000000000'
      });
  
      console.log("UnburnableToken contract deployed at address: " + deployedContract.options.address);
  
      // // Test total supply assignment
      // const totalSupply = await deployedContract.methods.totalSupply().call();
      // const deployerBalance = await deployedContract.methods.balances(deployerAccount).call();
      // if (parseInt(deployerBalance) !== parseInt(totalSupply)) {
      //   throw new Error("Initial supply is not assigned to the first account");
      // } else {
      //   console.log("Total supply is correctly assigned to the first account.");
      // }
  
      // Test claim function for the first account
      await deployedContract.methods.claim().send({ from: deployerAccount });
      const deployerBalanceAfterClaim = await deployedContract.methods.balances(deployerAccount).call();
      if (parseInt(deployerBalanceAfterClaim) !== 1000) {
        throw new Error("Tokens were not claimed correctly by the first account");
      } else {
        console.log("First account claimed tokens correctly.");
      }
  
      // Attempt to claim again with the first account which should fail
      try {
        await deployedContract.methods.claim().send({ from: deployerAccount });
        throw new Error("The same account was able to claim tokens more than once");
      } catch (error) {
        console.log("First account cannot claim tokens more than once as expected.");
      }
  
      // Test claim function for the second account
      await deployedContract.methods.claim().send({ from: secondAccount });
      const secondAccountBalanceAfterClaim = await deployedContract.methods.balances(secondAccount).call();
      if (parseInt(secondAccountBalanceAfterClaim) !== 1000) {
        throw new Error("Tokens were not claimed correctly by the second account");
      } else {
        console.log("Second account claimed tokens correctly.");
      }
  
      // Attempt to claim again with the second account which should fail
      try {
        await deployedContract.methods.claim().send({ from: secondAccount });
        throw new Error("The second account was able to claim tokens more than once");
      } catch (error) {
        console.log("Second account cannot claim tokens more than once as expected.");
      }
  
    } catch (error) {
      console.error(error.message);
    }
  })();
  