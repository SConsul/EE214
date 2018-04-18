library ieee;
use ieee.std_logic_1164.all;

entity slowto1000 is
  port (reset, CLK_50M: in std_logic; CLK_1k: out std_logic);
end entity slowto1000;


architecture slow of slowto1000 is

component slow16 is
  port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
end component;

component slow5 is
		port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
	end component;
	
signal s1, s2, s3, s4, s5 : std_logic;
begin 
--Need 1 slow16, 5 slow5 to convert50Mhx to 128Hz
sl1: slow5 port map(reset=>reset, fast_clk=>CLK_50M, slow_clk=>s1);
sl2: slow5 port map(reset=>reset, fast_clk=>s1,  slow_clk=>s2);
sl3: slow5 port map(reset=>reset, fast_clk=>s2,  slow_clk=>s3);
sl4: slow5 port map(reset=>reset, fast_clk=>s3,  slow_clk=>s4);
sl5: slow5 port map(reset=>reset, fast_clk=>s4,  slow_clk=>s5);
sl6: slow16 port map(reset=>reset, fast_clk=>s5,  slow_clk=>CLK_1k);

end slow;