library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
port(reset, x, clk: in std_logic; 
		y : out std_logic);
end entity;
architecture behave of debouncer is
	component DFlipFlop is
		port (reset, D, CLK: in std_logic; Q: out std_logic);
	end component;
	
	signal ns,s : std_logic_vector(1 downto 0);
	
begin 

ns(0) <= x and (not reset);
ns(1) <=  ( (x and s(0) and not s(1)) or (x and s(1) and not s(0)) or (s(1) and s(0)) ) and not reset;

y <= ( (x and s(0) and not s(1)) or (x and s(1) and not s(0)) or (s(1) and s(0)) ) and not reset;

dff_s0: DFlipFlop port map(reset=>reset, D=>ns(0) , CLK=>clk, Q=>s(0));
dff_s1: DFlipFlop port map(reset=>reset, D=>ns(1) , CLK=>clk, Q=>s(1));
end behave;
