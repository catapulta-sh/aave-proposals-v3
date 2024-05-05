# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv
# Deprecated - we now inline the full test command, so it's easier to adjust -vv(vv)
test-contract :; FOUNDRY_PROFILE=${chain} forge test --match-contract ${filter} -vvvv

# Deploy
deploy-ledger :; FOUNDRY_PROFILE=${chain} forge script ${contract} --rpc-url ${chain} $(if ${dry},--sender 0x25F2226B597E8F9514B3F68F00f494cF4f286491 -vvvv, --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow --broadcast)
deploy-pk :; FOUNDRY_PROFILE=${chain} forge script ${contract} --rpc-url ${chain} $(if ${dry},--sender 0x25F2226B597E8F9514B3F68F00f494cF4f286491 -vvvv, --private-key ${PRIVATE_KEY} --verify -vvvv --slow --broadcast)


# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@npx prettier ${before} ${after} --write
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md
