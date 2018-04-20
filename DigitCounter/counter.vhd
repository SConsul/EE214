library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity midsemcir is
port(x : in std_logic_vector(7 downto 0);
		y : out std_logic_vector(3 downto 0) );
end entity;
architecture behave of midsemcir is
component CSA is
   port(x0,x1,x2: in std_logic;
        s,cout: out std_logic);
end component;
	signal q: std_logic_vector (2 downto 0);
	signal r: std_logic_vector (2 downto 0);
	signal t: std_logic_vector (1 downto 0);
	signal v: std_logic_vector (1 downto 0);
begin

   csa_11: CSA port map (x0 => x(0), x1 => x(1), x2 => x(2), s=>r(0), cout=>q(0) );
   csa_12: CSA port map (x0 => x(3), x1 => x(4), x2 => x(5), s=>r(1), cout=>q(1) );
   csa_13: CSA port map (x0 => x(6), x1 => x(7), x2 => '0',  s=>r(2), cout=>q(2) );

   csa_21: CSA port map (x0 => r(0), x1 => r(1), x2 => r(2), s=>y(0), cout=>t(0) );
   csa_22: CSA port map (x0 => q(0), x1 => q(1), x2 => q(2), s=>t(1), cout=>v(0) );

   csa_31: CSA port map (x0 => t(0), x1 => t(1), x2 => '0',  s=>y(1), cout=>v(1) );

   csa_41: CSA port map (x0 => v(0), x1 => v(1), x2 => '0',  s=>y(2), cout=>y(3) );

		
end behave;
