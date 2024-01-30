(async () => {
    try {
        const accounts = await web3.eth.getAccounts();
        const deployerAccount = accounts[0];
        const tokenHolderAccount = accounts[1]; // Different account to test various functionalities
        const metadata = JSON.parse(await remix.call('fileManager', 'getFile', 'baseCamp/remix/tokenDev/ERC20/artifacts/WeightedVoting.json'));

        // Deploy the WeightedVoting contract
        const contractInstance = new web3.eth.Contract(metadata.abi);
        const bytecode = metadata.data.bytecode.object;

        const deployedContract = await contractInstance.deploy({
            data: bytecode
        }).send({
            from: deployerAccount,
            gas: 200000000,
            gasPrice: '30000000000'
        });

        console.log("WeightedVoting contract deployed at address: " + deployedContract.options.address);

        // Test the claim function for deployer account
        await deployedContract.methods.claim().send({ from: deployerAccount });
        const deployerBalance = await deployedContract.methods.balances(deployerAccount).call();
        if (parseInt(deployerBalance) !== 100 * 1e18) {
            throw new Error("Claim function did not work correctly for deployer account");
        } else {
            console.log("Claim function works correctly for deployer account.");
        }

        // Test the claim function for token holder account
        await deployedContract.methods.claim().send({ from: tokenHolderAccount });
        const tokenHolderBalance = await deployedContract.methods.balances(tokenHolderAccount).call();
        if (parseInt(tokenHolderBalance) !== 100 * 1e18) {
            throw new Error("Claim function did not work correctly for token holder account");
        } else {
            console.log("Claim function works correctly for token holder account.");
        }

        // Test creating an issue
        const issueDescription = "New Voting Issue";
        const quorum = web3.utils.toBN("50").mul(web3.utils.toBN("1e18")); // Correct handling of BigNumber for quorum
        const issueTx = await deployedContract.methods.createIssue(issueDescription, quorum).send({
            from: tokenHolderAccount
        });

        // Log created issue
        const issueEvent = issueTx.events.IssueCreated;
        const issueId = issueEvent.returnValues.issueId;

        console.log("Issue created with ID: " + issueId);

        // Test voting on an issue
        await deployedContract.methods.vote(issueId, 1 /* FOR vote */).send({ from: tokenHolderAccount }); // Voting FOR the issue
        const issueInfo = await deployedContract.methods.getIssue(issueId).call();
        if (issueInfo.votesFor !== tokenHolderBalance) {
            throw new Error("Vote function did not work correctly");
        } else {
            console.log("Vote function works correctly.\n\nSUCCESS! HOOORAY!");
        }

    } catch (error) {
        console.error(error.message);
    }
})();
