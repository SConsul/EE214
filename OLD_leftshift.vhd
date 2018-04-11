library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
entity L0SHIFT is
  port (a: in std_logic_vector; b: in std_logic;
         s_out: out std_logic_vector);
end entity L0SHIFT;
architecture Behave of L0SHIFT is
signal s_a0: std_logic_vector (7 downto 0);
begin
  s_a0(7) <= a(6);
  s_a0(6) <= a(5);
  s_a0(5) <= a(4);
  s_a0(4) <= a(3);
  s_a0(3) <= a(2);
  s_a0(2) <= a(1);
  s_a0(1) <= a(0);
  s_a0(0) <= '0';  
  s_out(7) <= (b and s_a0(7)) or ((not b) and a(7));
  s_out(6) <= (b and s_a0(6)) or ((not b) and a(6));
  s_out(5) <= (b and s_a0(5)) or ((not b) and a(5));
  s_out(4) <= (b and s_a0(4)) or ((not b) and a(4));
  s_out(3) <= (b and s_a0(3)) or ((not b) and a(3));
  s_out(2) <= (b and s_a0(2)) or ((not b) and a(2));
  s_out(1) <= (b and s_a0(1)) or ((not b) and a(1));
  s_out(0) <= (b and s_a0(0)) or ((not b) and a(0));
end Behave;

library ieee;
use ieee.std_logic_1164.all;
entity L1SHIFT is
  port (a:in std_logic_vector; b: in std_logic;
         s_out: out std_logic_vector);
end entity L1SHIFT;
architecture Behave of L1SHIFT is
signal s_a1: std_logic_vector (7 downto 0);
begin
  s_a1(7) <= a(5);
  s_a1(6) <= a(4);
  s_a1(5) <= a(3);
  s_a1(4) <= a(2);
  s_a1(3) <= a(1);
  s_a1(2) <= a(0);
  s_a1(1) <= '0';
  s_a1(0) <= '0';  
  s_out(7) <= (b and s_a1(7)) or ((not b) and a(7));
  s_out(6) <= (b and s_a1(6)) or ((not b) and a(6));
  s_out(5) <= (b and s_a1(5)) or ((not b) and a(5));
  s_out(4) <= (b and s_a1(4)) or ((not b) and a(4));
  s_out(3) <= (b and s_a1(3)) or ((not b) and a(3));
  s_out(2) <= (b and s_a1(2)) or ((not b) and a(2));
  s_out(1) <= (b and s_a1(1)) or ((not b) and a(1));
  s_out(0) <= (b and s_a1(0)) or ((not b) and a(0));
end Behave;

library ieee;
use ieee.std_logic_1164.all;
entity L2SHIFT is
  port (a:in std_logic_vector; b: in std_logic;
         s_out: out std_logic_vector);
end entity L2SHIFT;
architecture Behave of L2SHIFT is
signal s_a2: std_logic_vector (7 downto 0);
begin
  s_a2(7) <= a(3);
  s_a2(6) <= a(2);
  s_a2(5) <= a(1);
  s_a2(4) <= a(0);
  s_a2(3) <= '0';
  s_a2(2) <= '0';
  s_a2(1) <= '0';
  s_a2(0) <= '0';  
  s_out(7) <= (b and s_a2(7)) or ((not b) and a(7));
  s_out(6) <= (b and s_a2(6)) or ((not b) and a(6));
  s_out(5) <= (b and s_a2(5)) or ((not b) and a(5));
  s_out(4) <= (b and s_a2(4)) or ((not b) and a(4));
  s_out(3) <= (b and s_a2(3)) or ((not b) and a(3));
  s_out(2) <= (b and s_a2(2)) or ((not b) and a(2));
  s_out(1) <= (b and s_a2(1)) or ((not b) and a(1));
  s_out(0) <= (b and s_a2(0)) or ((not b) and a(0));
  
end Behave;

library ieee;
use ieee.std_logic_1164.all;
entity L3SHIFT is
  port (a,b:in std_logic_vector; 
         s_out: out std_logic_vector);
end entity L3SHIFT;
architecture Behave of L3SHIFT is
signal s_a3: std_logic_vector (7 downto 0) ; 
signal sel: std_logic;
begin
  s_a3 <="00000000";
  sel <= (b(7) or b(6) or b(5) or b(4) or b(3));
  s_out(7) <= (sel and s_a3(7)) or ((not sel) and a(7));
  s_out(6) <= (sel and s_a3(6)) or ((not sel) and a(6));
  s_out(5) <= (sel and s_a3(5)) or ((not sel) and a(5));
  s_out(4) <= (sel and s_a3(4)) or ((not sel) and a(4));
  s_out(3) <= (sel and s_a3(3)) or ((not sel) and a(3));
  s_out(2) <= (sel and s_a3(2)) or ((not sel) and a(2));
  s_out(1) <= (sel and s_a3(1)) or ((not sel) and a(1));
  s_out(0) <= (sel and s_a3(0)) or ((not sel) and a(0));
end Behave;
library ieee;
-- std_logic type and associated functions.
use ieee.std_logic_1164.all;

library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity leftshift is
port(x,y : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0) );
end entity;
architecture behave of leftshift is
component L0SHIFT is
  port (a:in std_logic_vector; b: in std_logic;
         s_out: out std_logic_vector);
end component L0SHIFT;

component L1SHIFT is
  port (a:in std_logic_vector; b: in std_logic;
         s_out: out std_logic_vector);
end component L1SHIFT;

component L2SHIFT is
  port (a:in std_logic_vector; b: in std_logic;
         s_out: out std_logic_vector);
end component L2SHIFT;

component L3SHIFT is
  port (a,b:in std_logic_vector; 
         s_out: out std_logic_vector);
end component L3SHIFT;

	signal s0, s1, s2,s3: std_logic_vector (7 downto 0);
begin
	s_0: L0SHIFT port map (a=>x, b=>y(0), s_out=>s0 );
	s_1: L1SHIFT port map (a=>s0, b=>y(1), s_out=>s1 );
	s_2: L2SHIFT port map (a=>s1, b=>y(2), s_out=>s2 );
	s_3: L3SHIFT port map (a=>s2, b=>y, s_out=>z );
end behave;

