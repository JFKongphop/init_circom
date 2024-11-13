# STEP

# compile circom
com:
	circom square_and_sum.circom --r1cs --wasm --sym

# compute witness
wit:
	node square_and_sum_js/generate_witness.js square_and_sum_js/square_and_sum.wasm json/input.json witness/witness.wtns

# create power of tua (random number)
ptua1:
	snarkjs powersoftau new bn128 12 ptua/pot12_0000.ptau -v

ptua2:
	snarkjs powersoftau contribute ptua/pot12_0000.ptau ptua/pot12_0001.ptau --name="First contribution" -v

# create specific circuit for final ptua
final-ptua:
	snarkjs powersoftau prepare phase2 ptua/pot12_0001.ptau ptua/pot12_final.ptau -v

# create zkey for prove verify
zkey1:
	snarkjs groth16 setup compile/square_and_sum.r1cs ptua/pot12_final.ptau zkey/square_and_sum0000.zkey

zkey2:
	snarkjs zkey contribute zkey/square_and_sum0000.zkey zkey/square_and_sum0001.zkey --name="1st Contributor Name" -v

# export key to json from zkey
ex-zkey:
	snarkjs zkey export verificationkey zkey/square_and_sum0001.zkey json/verification_key.json

# generate proof return proof.json and public.json
gen-proof:
	snarkjs groth16 prove zkey/square_and_sum0001.zkey witness/witness.wtns json/proof.json json/public.json

# check proof is correct if change variable in proof.json or value in public.json the result is false
verify-proof:
	snarkjs groth16 verify json/verification_key.json json/public.json json/proof.json

# generate smart contract verify of the proof
gen-sol-verify:
	snarkjs zkey export solidityverifier zkey/square_and_sum0001.zkey verifier/square_and_sum.sol

# generalcall the data for smart contract verify
gencall:
	snarkjs generatecall json/public.json json/proof.json > generatecall/square_and_sum.txt