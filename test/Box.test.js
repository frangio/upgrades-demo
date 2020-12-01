contract('Box', function (accounts) {
  it('ok', async function () {
    const Box = await ethers.getContractFactory("Box");
    const box = await upgrades.deployProxy(Box, [42], { initializer: 'store' });
    await Box.deploy();
  });
});
