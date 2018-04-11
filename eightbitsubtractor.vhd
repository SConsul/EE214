--library ieee;
--use ieee.std_logic_1164.all;
--entity XOR_2 is
-- 	port (a, b: in std_logic; c : out std_logic);
--end entity;
--architecture Behave of XOR_2 is
--begin
--  c <= (a and (not b)) or (b and (not a));
--end Behave;


library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
entity FULLSUBTRACTOR is
  port (a, b, bin: in std_logic;
         bout, d: out std_logic);
end entity FULLSUBTRACTOR;
architecture Behave of FULLSUBTRACTOR is
component XOR_2 is
		port (a, b: in std_logic; c : out std_logic);
end component;
	signal s1: std_logic;
begin
  bout <= ( (bin and b) or (bin and (not a)) or ((not a)and b) );
 -- d <= ((a xor b) xor bin);
  x1: XOR_2 port map (a => a, b => b, c => s1);
  x2: XOR_2 port map (a => s1, b => bin, c => d);
end Behave;

library ieee;
-- std_logic type and associated functions.
use ieee.std_logic_1164.all;


library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity eightbitsubtractor is
port(x,y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0) );
end entity;
architecture behave of eightbitsubtractor is
component FULLSUBTRACTOR is
		port (a, b, bin: in std_logic; bout ,d: out std_logic);
   end component;
	signal s: std_logic_vector (7 downto 0);
begin
	fs_0: FULLSUBTRACTOR port map (a=>x(0), b=>y(0), bin=>'0',  bout=>s(0), d=>z(0) );
	fs_1: FULLSUBTRACTOR port map (a=>x(1), b=>y(1), bin=>s(0), bout=>s(1), d=>z(1) );
	fs_2: FULLSUBTRACTOR port map (a=>x(2), b=>y(2), bin=>s(1), bout=>s(2), d=>z(2) );
	fs_3: FULLSUBTRACTOR port map (a=>x(3), b=>y(3), bin=>s(2), bout=>s(3), d=>z(3) );
	fs_4: FULLSUBTRACTOR port map (a=>x(4), b=>y(4), bin=>s(3), bout=>s(4), d=>z(4) );
	fs_5: FULLSUBTRACTOR port map (a=>x(5), b=>y(5), bin=>s(4), bout=>s(5), d=>z(5) );
	fs_6: FULLSUBTRACTOR port map (a=>x(6), b=>y(6), bin=>s(5), bout=>s(6), d=>z(6) );
	fs_7: FULLSUBTRACTOR port map (a=>x(7), b=>y(7), bin=>s(6), bout=>s(7), d=>z(7) );
end behave;

