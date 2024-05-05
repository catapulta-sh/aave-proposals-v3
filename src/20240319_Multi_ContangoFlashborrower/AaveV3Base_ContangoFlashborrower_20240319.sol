// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Base} from 'aave-address-book/AaveV3Base.sol';

/**
 * @title Contango FlashBorrower
 * @author Aave Chan Initiative
 * - Snapshot: https://snapshot.org/#/aave.eth/proposal/0x09bb9e7cffc974d330d82ce7a0b0502b573d6f3b4f839ea15d6629613901e96d
 * - Discussion: https://governance.aave.com/t/arfc-add-contango-protocol-cian-protocol-and-index-coop-to-flashborrowers-on-aave-v3/16478
 */
contract AaveV3Base_ContangoFlashborrower_20240319 is IProposalGenericExecutor {
  address public constant NEW_FLASH_BORROWER = 0xab515542d621574f9b5212d50593cD0C07e641bD;

  function execute() external {
    AaveV3Base.ACL_MANAGER.addFlashBorrower(NEW_FLASH_BORROWER);
  }
}
