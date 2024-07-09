// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV3Metis} from 'aave-address-book/AaveV3Metis.sol';

import 'forge-std/Test.sol';
import {ProtocolV3TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveV3Metis_RenewalOfAaveGuardian2024_20240708} from './AaveV3Metis_RenewalOfAaveGuardian2024_20240708.sol';

/**
 * @dev Test for AaveV3Metis_RenewalOfAaveGuardian2024_20240708
 * command: FOUNDRY_PROFILE=metis forge test --match-path=src/20240708_Multi_RenewalOfAaveGuardian2024/AaveV3Metis_RenewalOfAaveGuardian2024_20240708.t.sol -vv
 */
contract AaveV3Metis_RenewalOfAaveGuardian2024_20240708_Test is ProtocolV3TestBase {
  AaveV3Metis_RenewalOfAaveGuardian2024_20240708 internal proposal;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('metis'), 17597358);
    proposal = new AaveV3Metis_RenewalOfAaveGuardian2024_20240708();
  }

  /**
   * @dev executes the generic test suite including e2e and config snapshots
   */
  function test_defaultProposalExecution() public {
    defaultTest(
      'AaveV3Metis_RenewalOfAaveGuardian2024_20240708',
      AaveV3Metis.POOL,
      address(proposal)
    );
  }
}
