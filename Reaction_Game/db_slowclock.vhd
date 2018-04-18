library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity db_slowclock is
		port (reset, fast : in std_logic; slow: out std_logic);
	end entity;
architecture behave of db_slowclock is
	
	component slow16 is
		port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
	end  component;
	
	component slow2 is
		port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
	end component;
	
	signal s41, s42, s43, s44, s21, s22: std_logic;
	
begin 
--5 lakh approx 2^19
s4_1: slow16 port map(reset=>reset, fast_clk=>fast, slow_clk=>s41);
s4_2: slow16 port map(reset=>reset, fast_clk=>s41, slow_clk=>s42);
s4_3: slow16 port map(reset=>reset, fast_clk=>s42, slow_clk=>s43);
s4_4: slow16 port map(reset=>reset, fast_clk=>s43, slow_clk=>s44);
s2_1: slow2 port map(reset=>reset, fast_clk=>s44, slow_clk=>s21);
s2_2: slow2 port map(reset=>reset, fast_clk=>s21, slow_clk=>s22);
s2_3: slow2 port map(reset=>reset, fast_clk=>s22, slow_clk=>slow);

end behave;
