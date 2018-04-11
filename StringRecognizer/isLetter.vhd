library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity isLetter is
port( ref,test : in std_logic_vector(4 downto 0);
		ans : out std_logic);
end entity;
architecture behave of isLetter is
	signal truth : std_logic_vector(4 downto 0);
begin
	truth(0) <=( (ref(0) and test(0) ) or (not ref(0) and not test(0)) );
	truth(1) <=( (ref(1) and test(1) ) or (not ref(1) and not test(1)) );
	truth(2) <=( (ref(2) and test(2) ) or (not ref(2) and not test(2)) );
	truth(3) <=( (ref(3) and test(3) ) or (not ref(3) and not test(3)) );
	truth(4) <=( (ref(4) and test(4) ) or (not ref(4) and not test(4)) );
	ans <= (truth(0) and truth(1) and truth(2) and truth(3) and truth(4) );
end behave;
