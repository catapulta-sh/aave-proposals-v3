// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {TransparentUpgradeableProxy} from 'solidity-utils/contracts/transparent-proxy/TransparentUpgradeableProxy.sol';
import {ProxyAdmin} from 'solidity-utils/contracts/transparent-proxy/ProxyAdmin.sol';
import {ChainIds} from 'aave-helpers/ChainIds.sol';
import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';
import {ICrossChainReceiver, ICrossChainForwarder} from 'aave-address-book/common/ICrossChainController.sol';
import {GovernanceV3Optimism} from 'aave-address-book/GovernanceV3Optimism.sol';

/**
 * @title aDI and bridge adapters update
 * @author BGD Labs @bgdlabs
 * - Snapshot: TODO
 * - Discussion: TODO
 */
contract AaveV3Optimism_ADIAndBridgeAdaptersUpdate_20240305 is IProposalGenericExecutor {
  address public constant NEW_ADAPTER = address(0); // TODO: change for real address when deployed
  address public constant NEW_CROSS_CHAIN_CONTROLLER_IMPLEMENTATION = address(0); // TODO: change for real address when deployed

  function execute() external {
    // custom code goes here
  }
}
