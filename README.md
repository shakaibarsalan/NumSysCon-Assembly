## Overview

**Number Conversion System** is an interactive 8086 assembly program that allows users to **convert numbers between binary, decimal, and hexadecimal formats**. The program supports both signed and unsigned decimal representations and provides negation (two's complement) for binary numbers. It is designed for educational purposes to demonstrate number system conversions and low-level input/output handling in assembly language.

## Features

- **Convert numbers between:**
  - **Binary**
  - **Decimal** (signed and unsigned)
  - **Hexadecimal**
- **Display negation** (two's complement) for binary numbers
- **User-friendly menu** for selecting conversion type
- **Graceful exit** and restart options after each conversion

## How It Works

1. **Startup:**  
   The program displays a menu with conversion options:
   - (b) Binary
   - (d) Decimal
   - (h) Hexadecimal
   - (e) Exit

2. **Input:**  
   The user selects a conversion type and is prompted to enter a number in the chosen format.

3. **Conversion & Output:**  
   - The program converts the input to all supported formats.
   - Displays:
     - The original number in all formats
     - The negation (two's complement) in binary
     - Both signed and unsigned decimal values

4. **Repeat or Exit:**  
   After displaying results, the user can perform another conversion or exit the program.

## Usage Instructions

### Prerequisites

- **8086 emulator** (such as DOSBox, EMU8086, or any compatible assembler/emulator)
- The source file: `Number-Conversion-System.asm`

### Compilation & Execution

1. **Assemble the program:**
   - Use your assembler (e.g., MASM, TASM, EMU8086) to assemble the `.asm` file.
2. **Run the executable** in your 8086 environment.

### Controls

- **Menu selection:**  
  Enter `b`, `d`, `h`, or `e` to choose the desired operation.
- **Number input:**  
  - For binary: Enter up to 16 bits (0s and 1s), then press Enter.
  - For decimal: Enter a signed or unsigned integer, then press Enter.
  - For hexadecimal: Enter up to 4 hex digits (0-9, A-F), then press Enter.
- **Exit:**  
  Enter `e` at the menu to quit.

## Code Structure

- **Main Loop:** Handles menu, input, and restarts after each conversion.
- **Input/Output Procedures:**  
  - `input_binary`, `input_decimal`, `input_hexadecimal`
  - `output_binary`, `unsigned_output_decimal`, `signed_output_decimal`, `output_hexadecimal`
- **Negation:**  
  - Displays two's complement of the entered number in binary.
- **Utility Procedures:**  
  - `newline`, `doneMessage`, `result`

## Notes

- **Input validation:** The program checks for valid input and prompts again if invalid data is entered.
- **Number range:**  
  - Decimal input supports values from **-32768 to 32767** (16-bit signed).
  - Binary and hexadecimal inputs are limited to 16 bits (4 hex digits).
- **Display formatting:** Binary output is grouped for readability.

## Example Session

> **Conversion you want to perform?**  
> (b) Binary  
> (d) Decimal  
> (h) Hexadecimal  
> (e) Exit  
> **Choose:** d  
>
> **Decimal # :** 25  
>
> **Result:**  
>  Binary # : 0000 0000 0001 1001  
>  Negation : 1111 1111 1110 0111  
>  Un-Sign Decimal # : 25  
>  Sign Decimal # : 25  
>  HexaDecimal # : 0019  
>  ===== Done Conversion =====

## Author & License

- **Author:** Muhammad Shakaib Arsalan
- **License:** For educational use only.
