contract('Token', function (accounts) {

  it('bad upgrade', async function () {
    const TokenV1 = await ethers.getContractFactory("TokenV1");
    const TokenV2 = await ethers.getContractFactory("TokenV2Bad");
    const c = await upgrades.deployProxy(TokenV1);

    await c.deployed();

    try {
      await upgrades.upgradeProxy(c.address, TokenV2);
      throw new Error('TokenV2 upgrade should have failed');
    } catch (e) {
      if (!e.message.includes('storage layout is incompatible')) {
        throw e;
      }
    }
  });


  it('good upgrade', async function () {
    const TokenV1 = await ethers.getContractFactory("TokenV1");
    const TokenV2 = await ethers.getContractFactory("TokenV2Good");
    const c = await upgrades.deployProxy(TokenV1);

    await c.deployed();

    await upgrades.upgradeProxy(c.address, TokenV2);
  });

});
