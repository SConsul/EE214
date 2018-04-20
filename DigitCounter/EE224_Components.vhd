library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity AND_2 is
   port (a, b: in std_logic; c : out std_logic);
end entity;
architecture behave of AND_2 is
begin
	c<=a and b;
end behave;

library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity OR_2 is
   port (a, b: in std_logic; c : out std_logic);
end entity;
architecture behave of OR_2 is
begin
	c<=a or b;
end behave;

library ieee;
use ieee.std_logic_1164.all;
entity XOR_2 is
  port (a, b: in std_logic;
         c: out std_logic);
end entity;
architecture Behave of XOR_2 is
begin
  c <= ((a and (not b)) or ((not a) and b));
end Behave;
