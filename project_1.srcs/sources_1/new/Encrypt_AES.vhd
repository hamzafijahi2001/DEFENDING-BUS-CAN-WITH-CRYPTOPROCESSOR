library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.AES_Pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_Encryptor is
    Port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        key       : in  std_logic_vector(127 downto 0);
        plaintext : in  std_logic_vector(127 downto 0);
        start     : in  std_logic;
        done      : out std_logic;
        ciphertext: out std_logic_vector(127 downto 0)
    );
end AES_Encryptor;

architecture Behavioral of AES_Encryptor is
    signal round_keys : key_type;
    signal state      : state_type;
    signal state_reg1      : state_type;
    signal state_reg2      : state_type;
    signal round      : integer := 0;
    signal busy       : std_logic := '0';


    type sbox_array is array(0 to 255) of std_logic_vector(7 downto 0);
    constant Sbox : sbox_array := (
            x"63", x"7C", x"77", x"7B", x"F2", x"6B", x"6F", x"C5", x"30", x"01", x"67", x"2B", x"FE", x"D7", x"AB", x"76",
            x"CA", x"82", x"C9", x"7D", x"FA", x"59", x"47", x"F0", x"AD", x"D4", x"A2", x"AF", x"9C", x"A4", x"72", x"C0",
            x"B7", x"FD", x"93", x"26", x"36", x"3F", x"F7", x"CC", x"34", x"A5", x"E5", x"F1", x"71", x"D8", x"31", x"15",
            x"04", x"C7", x"23", x"C3", x"18", x"96", x"05", x"9A", x"07", x"12", x"80", x"E2", x"EB", x"27", x"B2", x"75",
            x"09", x"83", x"2C", x"1A", x"1B", x"6E", x"5A", x"A0", x"52", x"3B", x"D6", x"B3", x"29", x"E3", x"2F", x"84",
            x"53", x"D1", x"00", x"ED", x"20", x"FC", x"B1", x"5B", x"6A", x"CB", x"BE", x"39", x"4A", x"4C", x"58", x"CF",
            x"D0", x"EF", x"AA", x"FB", x"43", x"4D", x"33", x"85", x"45", x"F9", x"02", x"7F", x"50", x"3C", x"9F", x"A8",
            x"51", x"A3", x"40", x"8F", x"92", x"9D", x"38", x"F5", x"BC", x"B6", x"DA", x"21", x"10", x"FF", x"F3", x"D2",
            x"CD", x"0C", x"13", x"EC", x"5F", x"97", x"44", x"17", x"C4", x"A7", x"7E", x"3D", x"64", x"5D", x"19", x"73",
            x"60", x"81", x"4F", x"DC", x"22", x"2A", x"90", x"88", x"46", x"EE", x"B8", x"14", x"DE", x"5E", x"0B", x"DB",
            x"E0", x"32", x"3A", x"0A", x"49", x"06", x"24", x"5C", x"C2", x"D3", x"AC", x"62", x"91", x"95", x"E4", x"79",
            x"E7", x"C8", x"37", x"6D", x"8D", x"D5", x"4E", x"A9", x"6C", x"56", x"F4", x"EA", x"65", x"7A", x"AE", x"08",
            x"BA", x"78", x"25", x"2E", x"1C", x"A6", x"B4", x"C6", x"E8", x"DD", x"74", x"1F", x"4B", x"BD", x"8B", x"8A",
            x"70", x"3E", x"B5", x"66", x"48", x"03", x"F6", x"0E", x"61", x"35", x"57", x"B9", x"86", x"C1", x"1D", x"9E",
            x"E1", x"F8", x"98", x"11", x"69", x"D9", x"8E", x"94", x"9B", x"1E", x"87", x"E9", x"CE", x"55", x"28", x"DF",
            x"8C", x"A1", x"89", x"0D", x"BF", x"E6", x"42", x"68", x"41", x"99", x"2D", x"0F", x"B0", x"54", x"BB", x"16"
        );

    -- Function prototypes for AES operations
    function SubBytes(s: state_type) return state_type;
    function ShiftRows(s: state_type) return state_type;
    function MixColumns(s: state_type) return state_type;
    function AddRoundKey(s: state_type; k: key_type; round: integer) return state_type;
    function KeyExpansion(key: std_logic_vector(127 downto 0)) return key_type;

    -- Internal processes for each AES operation

    -- Implementation for SubBytes 
    function SubBytes(s: state_type) return state_type is
            variable result : state_type;
            variable row, col : integer;
        begin
            for i in 0 to Nb-1 loop
                for j in 0 to Nb-1 loop
                    row := conv_integer(s(i, j)(7 downto 4));
                    col := conv_integer(s(i, j)(3 downto 0));
                    result(i, j) := Sbox(row * 16 + col);
                end loop;
            end loop;
            return result;
        end SubBytes;

    -- Implementation for ShiftRows 
    function ShiftRows(s: state_type) return state_type is
        variable result : state_type;
    begin
        result(0, 0) := s(0, 0);
        result(0, 1) := s(0, 1);
        result(0, 2) := s(0, 2);
        result(0, 3) := s(0, 3);
        result(1, 0) := s(1, 1);
        result(1, 1) := s(1, 2);
        result(1, 2) := s(1, 3);
        result(1, 3) := s(1, 0);
        result(2, 0) := s(2, 2);
        result(2, 1) := s(2, 3);
        result(2, 2) := s(2, 0);
        result(2, 3) := s(2, 1);
        result(3, 0) := s(3, 3);
        result(3, 1) := s(3, 0);
        result(3, 2) := s(3, 1);
        result(3, 3) := s(3, 2);
        return result;
    end ShiftRows;

    -- Implementation for MixColumns 
    function MixColumns(s: state_type) return state_type is
        variable result : state_type;
    begin
        result := s;
        return result;
    end MixColumns;

    -- Implementation for AddRoundKey
    function AddRoundKey(s: state_type; k: key_type; round: integer) return state_type is
        variable result : state_type;
    begin
        for i in 0 to Nb-1 loop
            for j in 0 to Nb-1 loop
                result(i, j) := s(i, j) xor k(round*Nb+i)(8*(j+1)-1 downto 8*j);
            end loop;
        end loop;
        return result;
    end AddRoundKey;
    
    type rcon_type is array(0 to 10) of std_logic_vector(31 downto 0);
    
    constant Rcon: rcon_type := (
        x"01000000", x"02000000", x"04000000", x"08000000",
        x"10000000", x"20000000", x"40000000", x"80000000",
        x"1B000000", x"36000000", others => (others => '0')
    );

    function RotateWord(word: std_logic_vector(31 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(31 downto 0);
    begin
        result := word(23 downto 0) & word(31 downto 24);
        return result;
    end function;
    
    function SubWord(word: std_logic_vector(31 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(31 downto 0);
    begin
        result(31 downto 24) := sbox(to_integer(unsigned(word(31 downto 24))));
        result(23 downto 16) := sbox(to_integer(unsigned(word(23 downto 16))));
        result(15 downto 8)  := sbox(to_integer(unsigned(word(15 downto 8))));
        result(7 downto 0)   := sbox(to_integer(unsigned(word(7 downto 0))));
        return result;
    end function;

    
    
    -- Implementation for KeyExpansion 
    function KeyExpansion(key: std_logic_vector(127 downto 0)) return key_type is
            variable result : key_type;
            variable temp : std_logic_vector(31 downto 0);
            variable i : integer;
        begin
            for i in 0 to Nk-1 loop
                result(i) := key(32*(i+1)-1 downto 32*i);
            end loop;
        
            -- Expand the key
            for i in Nk to (Nb*(Nr+1))-1 loop
                temp := result(i-1);
                if (i mod Nk) = 0 then
                    temp := SubWord(RotateWord(temp)) xor Rcon(i/Nk);
                end if;
                result(i) := result(i-Nk) xor temp;
            end loop;
        
            return result;
        end function;

begin

    process(clk, rst)
    begin
        if rst = '1' then
            state <= (others => (others => (others => '0')));
            round <= 0;
            busy <= '0';
            done <= '0';
            ciphertext <= (others => '0');
        elsif rising_edge(clk) then
            if start = '1' and busy = '0' then
                -- Initialize state and round keys
                round_keys <= KeyExpansion(key);
                for i in 0 to Nb-1 loop
                    for j in 0 to Nb-1 loop
                        state(i, j) <= plaintext(8*((4*i+j) + 1)-1 downto 8*(4*i+j));
                    end loop;
                end loop;
                round <= 0;
                busy <= '1';
            elsif busy = '1' then
                -- Perform AES rounds
                if round = 0 then
                    state_reg1 <= AddRoundKey(state, round_keys, round);
                elsif round < Nr then

                    state_reg1 <= AddRoundKey(MixColumns(ShiftRows(SubBytes(state_reg1))), round_keys, round);
                else
                    state_reg2 <= AddRoundKey(ShiftRows(SubBytes(state_reg1)), round_keys, round);
                    busy <= '0';
                    done <= '1';
                    for i in 0 to Nb-1 loop
                        for j in 0 to Nb-1 loop
                            ciphertext(8*((4*i+j) + 1)-1 downto 8*(4*i+j)) <= state_reg2(i, j);
                        end loop;
                    end loop;
                end if;
                round <= round + 1;
            end if;
        end if;
    end process;
end Behavioral;
