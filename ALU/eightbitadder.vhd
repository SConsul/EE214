--EIGHT BIT ADDER

--XOR GATE
library ieee;
use ieee.std_logic_1164.all;
entity XOR_2 is
 	port (a, b: in std_logic; c : out std_logic);
end entity;
architecture Behave of XOR_2 is
begin
  c <= (a and (not b)) or (b and (not a));
end Behave;

--FULL ADDER
library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
entity FULLADDER is
  port (a, b, cin: in std_logic;
         cout, s: out std_logic);
end entity FULLADDER;
architecture Behave of FULLADDER is
component XOR_2 is
		port (a, b: in std_logic; c : out std_logic);
   end component;
signal s1: std_logic;
begin
  cout <= ((a and b) or ((a and cin) or (b and cin)));
  x1: XOR_2 port map (a => a, b => b, c => s1);
  x2: XOR_2 port map (a => s1, b => cin, c => s);
  --s <= ((a xor b) xor cin);
end Behave;

library ieee;
-- std_logic type and associated functions.
use ieee.std_logic_1164.all;

--8 BIT ADDER
library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity eightbitadder is
port(x,y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0) );
end entity;
architecture behave of eightbitadder is
component FULLADDER is
		port (a, b, cin: in std_logic; cout ,s: out std_logic);
   end component;
	signal s: std_logic_vector (7 downto 0);
begin
	f_0: FULLADDER port map (a=>x(0), b=>y(0), cin=>'0',    cout=>s(0), s=>z(0) );
	f_1: FULLADDER port map (a=>x(1), b=>y(1), cin=>s(0), cout=>s(1), s=>z(1) );
	f_2: FULLADDER port map (a=>x(2), b=>y(2), cin=>s(1), cout=>s(2), s=>z(2) );
	f_3: FULLADDER port map (a=>x(3), b=>y(3), cin=>s(2), cout=>s(3), s=>z(3) );
	f_4: FULLADDER port map (a=>x(4), b=>y(4), cin=>s(3), cout=>s(4), s=>z(4) );
	f_5: FULLADDER port map (a=>x(5), b=>y(5), cin=>s(4), cout=>s(5), s=>z(5) );
	f_6: FULLADDER port map (a=>x(6), b=>y(6), cin=>s(5), cout=>s(6), s=>z(6) );
	f_7: FULLADDER port map (a=>x(7), b=>y(7), cin=>s(6), cout=>s(7), s=>z(7) );
end behave;

