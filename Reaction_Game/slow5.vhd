library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity slow5 is
port(reset, fast_clk : in std_logic; 
		slow_clk : out std_logic);
end entity slow5;
architecture behave of slow5 is
	component DFlipFlop is
		port (reset, D, CLK: in std_logic; Q: out std_logic);
	end component;
	signal ns, s : std_logic_vector(3 downto 0);
	
begin

ns(0) <=(not s(3) and not s(2) and not s(1) and not s(0)) and fast_clk and (not reset);
			
ns(1) <= (not s(3) and not s(2) and not s(1) and s(0)) and fast_clk and (not reset);

ns(2) <=(not s(3) and not s(2) and s(1) and not s(0)) and fast_clk and (not reset);

ns(3) <=(not s(3) and s(2) and s(1) and not s(0)) and fast_clk and (not reset);
			
slow_clk <= s(3) and fast_clk and (not reset);

dff_0: DFlipFlop port map(reset=>reset, D=>ns(0) , CLK=>fast_clk, Q=>s(0));
dff_1: DFlipFlop port map(reset=>reset, D=>ns(1) , CLK=>fast_clk, Q=>s(1));
dff_2: DFlipFlop port map(reset=>reset, D=>ns(2) , CLK=>fast_clk, Q=>s(2));
dff_3: DFlipFlop port map(reset=>reset, D=>ns(3) , CLK=>fast_clk, Q=>s(3));
end behave;