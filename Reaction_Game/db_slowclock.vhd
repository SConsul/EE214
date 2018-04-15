library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity db_slowclock is
		port (reset, fast : in std_logic; slow: out std_logic);
	end entity;
architecture behave of db_slowclock is
	component DFlipFlop is
		port (reset, D, CLK: in std_logic; Q: out std_logic);
	end component;
	
	component db_slow16 is
		port (reset, CLK: in std_logic; Q: out std_logic);
	end component;
	
	component db_slow2 is
		port (reset, CLK: in std_logic; Q: out std_logic);
	end component;
	
	signal s41, s42, s43, s44, s21, s22: std_logic;
	
begin 
--5 lakh approx 2^19
s4_1: db_slow16 port map(reset=>reset, CLK=>fast, Q=>s41);
s4_2: db_slow16 port map(reset=>reset, CLK=>s41, Q=>s42);
s4_3: db_slow16 port map(reset=>reset, CLK=>s42, Q=>s43);
s4_4: db_slow16 port map(reset=>reset, CLK=>s43, Q=>s44);
s2_1: db_slow2 port map(reset=>reset, CLK=>s44, Q=>s21);
s2_2: db_slow2 port map(reset=>reset, CLK=>s21, Q=>s22);
s2_3: db_slow2 port map(reset=>reset, CLK=>s22, Q=>slow);

end behave;
