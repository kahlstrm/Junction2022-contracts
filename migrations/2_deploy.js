// migrations/2_deploy.js
// SPDX-License-Identifier: MIT
const SoulBoundToken = artifacts.require("SoulBoundToken");

module.exports = function(deployer) {
  deployer.deploy(SoulBoundToken, "My Soulbound Certificate","SBTC");
};