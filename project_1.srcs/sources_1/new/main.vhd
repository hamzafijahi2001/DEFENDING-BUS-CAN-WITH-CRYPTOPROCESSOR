library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package AES_Pkg is
    constant Nb : integer := 4; -- Number of columns (32-bit words) comprising the State
    constant Nk : integer := 4; -- Number of 32-bit words comprising the Cipher Key
    constant Nr : integer := 10; -- Number of rounds
    subtype word is std_logic_vector(31 downto 0);
    type state_type is array (0 to Nb-1, 0 to Nb-1) of std_logic_vector(7 downto 0);
    type key_type is array (0 to (Nb*(Nr+1))-1) of word;
end AES_Pkg;

package body AES_Pkg is
end AES_Pkg;
