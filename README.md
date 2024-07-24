# DEFENDING-BUS-CAN-WITH-CRYPTOPROCESSOR

This repository contains a VHDL implementation of an AES (Advanced Encryption Standard) encryption module, designed to secure CAN (Controller Area Network) bus communication with a cryptoprocessor. The project includes the main AES encryption module and a testbench for verification.

## Description

The `DEFENDING-BUS-CAN-WITH-CRYPTOPROCESSOR` project aims to enhance the security of CAN bus communication by integrating an AES encryption module. AES is a widely used encryption algorithm that ensures data confidentiality and integrity. This VHDL implementation provides a robust solution for protecting data transmitted over the CAN bus.

## Project Structure

- `AES_Encryptor.vhdl`: The main VHDL file containing the AES encryption module.
- `AES_Encryptor_tb.vhdl`: The VHDL testbench for testing the AES encryption module.

## AES_Encryptor Entity

### Ports

- `clk` (in `std_logic`): Clock signal.
- `rst` (in `std_logic`): Reset signal.
- `key` (in `std_logic_vector(127 downto 0)`): 128-bit encryption key.
- `plaintext` (in `std_logic_vector(127 downto 0)`): 128-bit plaintext input.
- `start` (in `std_logic`): Start signal for encryption.
- `done` (out `std_logic`): Signal indicating encryption completion.
- `ciphertext` (out `std_logic_vector(127 downto 0)`): 128-bit ciphertext output.

## Key Features

- **SubBytes**: Substitution step using an S-box.
- **ShiftRows**: Shifting rows of the state array.
- **MixColumns**: Mixing columns of the state array.
- **AddRoundKey**: Adding round keys to the state array.
- **KeyExpansion**: Expanding the initial key to generate round keys.

## Installation

To use this project, follow these steps:

1. **Clone the repository**:
   ```sh
   git clone https://github.com/hamzafijahi2001/DEFENDING-BUS-CAN-WITH-CRYPTOPROCESSOR.git
   ```

2. **Navigate to the project directory**:
   ```sh
   cd DEFENDING-BUS-CAN-WITH-CRYPTOPROCESSOR
   ```

3. **Open the VHDL files**:
   Use your preferred VHDL editor or simulation environment to open and edit the VHDL files.

4. **Run the simulation**:
   Use a VHDL simulator to run the simulation with the provided testbench (`AES_Encryptor_tb.vhdl`) to verify the functionality of the AES encryption module.

## Usage

1. **Initialize the signals** in the testbench.
2. **Provide the clock signal**.
3. **Apply the reset signal**, set the start signal, and provide the key and plaintext inputs.
4. **Wait for the done signal** and verify the output ciphertext.

## Contributing

Contributions are welcome! If you have any suggestions or find any issues, please open an issue or submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or inquiries, please contact [Hamza FIJAHI] at [hamza.fijahi@gmail.com].

---

This README provides an overview of the DEFENDING-BUS-CAN-WITH-CRYPTOPROCESSOR project, including installation instructions, key features, and usage guidelines.
