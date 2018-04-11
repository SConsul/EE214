library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity flip is
  port (a:in std_logic_vector; 
         b: out std_logic_vector);
end entity flip;
architecture Behave of flip is

begin
  b(7)<=a(0);
  b(6)<=a(1);
  b(5)<=a(2);
  b(4)<=a(3);
  b(3)<=a(4);
  b(2)<=a(5);
  b(1)<=a(6);  
  b(0)<=a(7);
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity rightshift is
port(x,y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0) );
end entity;
architecture behave of rightshift is
component flip is
  port (a:in std_logic_vector; 
         b: out std_logic_vector);
end component flip;

component leftshift is
port(x,y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0) );
end component;

	signal f1, f2: std_logic_vector (7 downto 0);
begin
	f_0: flip port map (a=>x, b=>f1);
	s_1: leftshift port map (x=>f1, y=>y, z=>f2 );
	f_2: flip port map (a=>f2, b=>z);
end behave;