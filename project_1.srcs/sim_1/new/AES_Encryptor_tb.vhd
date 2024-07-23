

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_Encryptor_tb is
--  Port ( );
end AES_Encryptor_tb;

architecture Behavioral of AES_Encryptor_tb is
component AES_Encryptor port
(
       clk       : in  std_logic;
       rst       : in  std_logic;
       key       : in  std_logic_vector(127 downto 0);
       plaintext : in  std_logic_vector(127 downto 0);
       start     : in  std_logic;
       done      : out std_logic;
       ciphertext: out std_logic_vector(127 downto 0)
 );
end component;
signal clk : std_logic:='0';
signal rst : std_logic:='0';
signal start : std_logic:='0';
signal done : std_logic:='0';
signal plaintext : std_logic_vector(0 to 127);
signal key : std_logic_vector(0 to 127);
signal ciphertext : std_logic_vector(0 to 127);
begin

uut : AES_Encryptor port map(rst => rst , clk => clk, start => start, plaintext => plaintext, key => key , ciphertext => ciphertext , done => done);
process
begin
        clk <= '0'; wait for 1 ns;
        clk <= '1'; wait for 1 ns;
end process;
rst <= '1', '0' after 100 ns;
start <= '1' after 20 ns ;
key <= x"e1e3b92735911198e1e3b92735911198";
plaintext <= x"03e3b92635f11190e1e3491735911198";
end Behavioral;

