// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Harmony, AaveV3HarmonyAssets} from 'aave-address-book/AaveV3Harmony.sol';

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';

/**
 * @title Freeze price feeds on v3 Harmony
 * @author BGD Labs (@bgdlabs)
 * - Discussion: https://governance.aave.com/t/bgd-technical-maintenance-proposals/15274/6
 */
contract AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122 is IProposalGenericExecutor {
  address[] public assets = [
    AaveV3HarmonyAssets.ONE_DAI_UNDERLYING,
    AaveV3HarmonyAssets.ONE_USDC_UNDERLYING,
    AaveV3HarmonyAssets.ONE_USDT_UNDERLYING,
    AaveV3HarmonyAssets.WONE_UNDERLYING,
    AaveV3HarmonyAssets.LINK_UNDERLYING,
    AaveV3HarmonyAssets.ONE_WBTC_UNDERLYING,
    AaveV3HarmonyAssets.ONE_ETH_UNDERLYING,
    AaveV3HarmonyAssets.ONE_AAVE_UNDERLYING
  ];

  address[] public priceAdapters = [
    0x981AB570aC289938F296b975C524B66FBF1B8774,
    0xA9F30e6ED4098e9439B2ac8aEA2d3fc26BcEbb45,
    0x05225Cd708bCa9253789C1374e4337a019e99D56,
    0x3105C276558Dd4cf7E7be71d73Be8D33bD18F211,
    0x80f2c02224a2E548FC67c0bF705eBFA825dd5439,
    0x945fD405773973d286De54E44649cc0d9e264F78,
    0x7fc3FCb14eF04A48Bb0c12f0c39CD74C249c37d8,
    0xFD858c8bC5ac5e10f01018bC78471bb0DC392247
  ];

  address public constant ZERO_IR_STRATEGY = 0x230E0321Cf38F09e247e50Afc7801EA2351fe56F;

  function execute() external {
    // set new asset price sources
    AaveV3Harmony.ORACLE.setAssetSources(assets, priceAdapters);

    // set zero interest rate strategy
    for (uint256 i = 0; i < assets.length; i++) {
      AaveV3Harmony.POOL_CONFIGURATOR.setReserveInterestRateStrategyAddress(
        assets[i],
        ZERO_IR_STRATEGY
      );
    }
  }
}
