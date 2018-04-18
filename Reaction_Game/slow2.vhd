library ieee;
use ieee.std_logic_1164.all;

entity slow2 is
  port (reset, fast_clk: in std_logic; slow_clk: out std_logic);
end entity;

architecture WhatDoYouCare of slow2 is

signal qsig : std_logic;
begin 
   process (fast_clk) 
   begin
	if(reset='1') then
		qsig <='0';
		slow_clk<=qsig;
	else if fast_clk'event and (fast_clk = '1') then
		  qsig<= not qsig;
	     slow_clk <= qsig;
		  
	end if;
	end if;
   end process;

end WhatDoYouCare;
