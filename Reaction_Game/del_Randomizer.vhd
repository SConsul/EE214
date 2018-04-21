--del_Randomizer is the counter from 1000 to 1999 (11 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity del_Randomizer is
  port (
			CLK, reset, start, react: in std_logic; 
			del: out unsigned (10 downto 0) );
end entity del_Randomizer;
--1k clock to countdown => 
--1000 = 0b01111101000
--1999 = 0b11111001111
--1024 = 0b10000000000

architecture randomize of del_Randomizer is
	constant o1 : unsigned (10 downto 0) := (0=>'0',1=>'0',2=>'0',4=>'0',10=>'0', others => '1');
	constant c_max : unsigned (10 downto 0) := (4=>'0', 5=>'0', others => '1');
	signal count_sig,del_sig : unsigned (10 downto 0);
begin 
	del<=del_sig;
	
	process (reset, start, react, CLK, count_sig, del_sig)
	
	variable count_var: unsigned (10 downto 0);
	variable del_var: unsigned (10 downto 0);	
		begin
			count_var:=count_sig;
			del_var:=del_sig;	
					
			if (rising_edge(CLK)) then
				if (reset='1') then
					count_var:= (10=>'1', others=>'0'); --1024--		
					del_var:=(10=>'1', others=>'0');
					
				elsif (start='1' or react='1') then
					del_var:=count_var;
				
				elsif(count_var = c_max) then
					count_var:= o1;
				else
					count_var:= count_sig+1;
				end if;
				count_sig <= count_var;
				del_sig <= del_var;
			end if;

	end process;
end randomize;
