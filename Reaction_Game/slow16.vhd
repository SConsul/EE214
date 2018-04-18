library ieee;
use ieee.std_logic_1164.all;

entity slow16 is
  port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
end entity;

architecture WhatDoYouCare of slow16 is

component slow2 is
		port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
	end component;
	
signal s2, s4, s8 : std_logic;
begin 

slowby2: slow2 port map(reset=>reset, fast_clk=>fast_clk , slow_clk=>s2);
slowby4: slow2 port map(reset=>reset, fast_clk=>s2, slow_clk=>s4);
slowby8: slow2 port map(reset=>reset, fast_clk=>s4, slow_clk=>s8);
slowby16: slow2 port map(reset=>reset, fast_clk=>s8, slow_clk=>slow_clk);

end WhatDoYouCare;
