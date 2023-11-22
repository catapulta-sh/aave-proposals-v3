// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Harmony, AaveV3HarmonyAssets} from 'aave-address-book/AaveV3Harmony.sol';

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122} from './AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122.sol';

/**
 * @dev Test for AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122
 * command: make test-contract filter=AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122
 */
contract AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122_Test is ProtocolV3TestBase {
  address public constant HARMONY_GUARDIAN = 0xb2f0C5f37f4beD2cB51C44653cD5D84866BDcd2D;
  mapping(address => uint256) public assetPrices;

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

  AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('harmony'), 50040261);
    proposal = new AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122();

    assetPrices[AaveV3HarmonyAssets.ONE_DAI_UNDERLYING] = 99997072;
    assetPrices[AaveV3HarmonyAssets.ONE_USDC_UNDERLYING] = 99993136;
    assetPrices[AaveV3HarmonyAssets.ONE_USDT_UNDERLYING] = 100033850;
    assetPrices[AaveV3HarmonyAssets.WONE_UNDERLYING] = 1365605;
    assetPrices[AaveV3HarmonyAssets.LINK_UNDERLYING] = 1427072607;
    assetPrices[AaveV3HarmonyAssets.ONE_WBTC_UNDERLYING] = 3719209300000;
    assetPrices[AaveV3HarmonyAssets.ONE_ETH_UNDERLYING] = 200987000000;
    assetPrices[AaveV3HarmonyAssets.ONE_AAVE_UNDERLYING] = 8926779000;
  }

  function test_proposalExecution() public {
    string memory beforeString = string(
      abi.encodePacked('AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122', '_before')
    );
    ReserveConfig[] memory configBefore = createConfigurationSnapshot(
      beforeString,
      AaveV3Harmony.POOL
    );

    GovHelpers.executePayload(vm, address(proposal), HARMONY_GUARDIAN);

    // check price adapters
    for (uint256 i = 0; i < assets.length; i++) {
      assertEq(AaveV3Harmony.ORACLE.getAssetPrice(assets[i]), assetPrices[assets[i]]);
    }

    // check interest rate strategy
    for (uint256 i = 0; i < assets.length; i++) {
      assertEq(
        AaveV3Harmony.POOL_CONFIGURATOR.getReserveInterestRateStrategyAddress(assets[i]),
        proposal.ZERO_IR_STRATEGY()
      );
    }

    string memory afterString = string(
      abi.encodePacked('AaveV3Harmony_FreezePriceFeedsOnV3Harmony_20231122', '_after')
    );
    ReserveConfig[] memory configAfter = createConfigurationSnapshot(
      afterString,
      AaveV3Harmony.POOL
    );

    diffReports(beforeString, afterString);

    configChangePlausibilityTest(configBefore, configAfter);

    e2eTest(AaveV3Harmony.POOL);
  }
}
