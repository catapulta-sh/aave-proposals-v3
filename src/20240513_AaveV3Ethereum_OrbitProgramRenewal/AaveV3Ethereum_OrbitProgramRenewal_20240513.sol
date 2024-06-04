// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {OrbitProgramData} from './OrbitProgramData.sol';
import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';

import {CollectorUtils, ICollector} from '../CollectorUtils.sol';

/// Helper interface to withdraw ETH
interface IWETH {
  function withdraw(uint256) external;
}

/**
 * @title Orbit Program Renewal
 * @author Aave Chan Initiative
 * - Snapshot: "https://snapshot.org/#/aave.eth/proposal/0x4a10e2a8ca95024d7cf0791aa82ed262c816ff0ee78bc2f3ab3487e70d731361"
 * - Discussion: https://governance.aave.com/t/arfc-orbit-program-renewal-may-2024/17683
 */
contract AaveV3Ethereum_OrbitProgramRenewal_20240513 is IProposalGenericExecutor {
  error EthTransferFailed(address account);

  using CollectorUtils for ICollector;

  function execute() external {
    // custom code goes here
    AaveV3Ethereum.COLLECTOR.transfer(
      AaveV3EthereumAssets.WETH_UNDERLYING,
      address(this),
      OrbitProgramData.TOTAL_WETH_REBATE
    );

    IWETH(AaveV3EthereumAssets.WETH_UNDERLYING).withdraw(OrbitProgramData.TOTAL_WETH_REBATE);

    OrbitProgramData.GasUsage[] memory usage = OrbitProgramData.getGasUsageData();
    uint256 usageLength = usage.length;
    for (uint256 i = 0; i < usageLength; i++) {
      (bool ok, ) = usage[i].account.call{value: usage[i].usage}('');
      if (!ok) revert EthTransferFailed(usage[i].account);
    }

    address[] memory orbitAddresses = OrbitProgramData.getOrbitAddresses();
    uint256 orbitAddressesLength = orbitAddresses.length;
    for (uint256 i = 0; i < orbitAddressesLength; i++) {
      AaveV3Ethereum.COLLECTOR.stream(
        CollectorUtils.CreateStreamInput({
          underlying: AaveV3EthereumAssets.GHO_UNDERLYING,
          receiver: orbitAddresses[i],
          amount: OrbitProgramData.STREAM_AMOUNT,
          start: block.timestamp,
          duration: OrbitProgramData.STREAM_DURATION
        })
      );
    }
  }
  receive() external payable {}
}
