library ieee;
use ieee.std_logic_1164.all;

entity slow2 is
  port (reset, CLK: in std_logic; Q: out std_logic);
end entity;

architecture WhatDoYouCare of slow2 is

signal qsig : std_logic;
begin 
   process (CLK) 
   begin
	if(reset='1') then
		qsig <='0';
		Q<=qsig;
	else if CLK'event and (CLK = '1') then
		  qsig<= not qsig;
	     Q <= qsig;
		  
	end if;
	end if;
   end process;

end WhatDoYouCare;