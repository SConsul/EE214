--del_Randomizer is the counter from 0 to 127 (7 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity del_Randomizer is
  port (
			CLK, reset, start, react: in std_logic; 
			del: out unsigned (7 downto 0) );
end entity del_Randomizer;

architecture randomize of del_Randomizer is
	constant o1 : unsigned (7 downto 0) := (0=>'1', others => '0');--128
	constant c_max : unsigned (7 downto 0) := (others => '1');--255
begin 
	
	process (reset, start, react, CLK)
		variable count_var: unsigned (7 downto 0);
		begin
			if (reset='1') then
				count_var:= "10100011"; --33+128--			
			elsif (start='1' or react='1') then
				del <= count_var;		
			elsif (CLK'event and CLK = '1') then
					if (count_var = c_max) then
						count_var:= o1;
					else 
						count_var:= count_var+1;
					end if;
			end if;

	end process;
end randomize;