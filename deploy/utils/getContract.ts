import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { Contract } from 'ethers';
import fs from 'fs';
import path from 'path';

const getAbi = (contractName: string, fromArtifactPath?: string) => {
  const subpath = fromArtifactPath ? `./../../${fromArtifactPath}/${contractName}.sol` : './abi';
  const file = path.join(__dirname, `${subpath}/${contractName}.json`);
  const { abi } = JSON.parse(fs.readFileSync(file, 'utf8'));
  return abi;
}

export default (signer: SignerWithAddress, contractName: string, address: string, fromArtifactPath?: string) => {
  const contract = new Contract(address, getAbi(contractName, fromArtifactPath), signer.provider);

  console.log(`${contractName} module deployed to: ${contract.address}`);

  return contract.connect(signer);
};