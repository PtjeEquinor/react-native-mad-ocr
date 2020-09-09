import { NativeModules } from 'react-native';

type MadOcrType = {
  multiply(a: number, b: number): Promise<number>;
};

const { MadOcr } = NativeModules;

export default MadOcr as MadOcrType;
