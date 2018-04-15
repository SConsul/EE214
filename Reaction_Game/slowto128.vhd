library ieee;
use ieee.std_logic_1164.all;

entity slowto128 is
  port (reset, CLK: in std_logic; Q: out std_logic);
end entity slowto128;

architecture slow of slowto128 is

component slow5 is
		port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
	end component;
	
signal s1, s2, s3, s4, s5, s6, s7 : std_logic;
begin 
--Need 8 slow5 to convert50Mhx to 128Hz
sl1: slow5 port map(reset=>reset, fast_clk=>CLK, slow_clk=>s1);
sl2: slow5 port map(reset=>reset, fast_clk=>s1,  slow_clk=>s2);
sl3: slow5 port map(reset=>reset, fast_clk=>s2,  slow_clk=>s3);
sl4: slow5 port map(reset=>reset, fast_clk=>s3,  slow_clk=>s4);
sl5: slow5 port map(reset=>reset, fast_clk=>s4,  slow_clk=>s5);
sl6: slow5 port map(reset=>reset, fast_clk=>s5,  slow_clk=>s6);
sl7: slow5 port map(reset=>reset, fast_clk=>s6,  slow_clk=>s7);
sl8: slow5 port map(reset=>reset, fast_clk=>s7,  slow_clk=>Q);
end slow;