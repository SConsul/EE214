library ieee;
use ieee.std_logic_1164.all;

entity slow4 is
  port (reset, CLK: in std_logic; Q: out std_logic);
end entity;

architecture WhatDoYouCare of slow4 is

component slow2 is
		port (reset, CLK: in std_logic; Q: out std_logic);
	end component;
	
signal s2, s4, s8 : std_logic;
begin 

slowby2: slow2 port map(reset=>reset, CLK=>CLK , Q=>s2);
slowby4: slow2 port map(reset=>reset, CLK=>s2, Q=>s4);
slowby8: slow2 port map(reset=>reset, CLK=>s4, Q=>s8);
slowby16: slow2 port map(reset=>reset, CLK=>s8, Q=>Q);

end WhatDoYouCare;