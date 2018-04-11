library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
port(reset, x, clk_5M : in std_logic; 
		y : out std_logic);
end entity;
architecture behave of debouncer is
	component DFlipFlop is
		port (reset, D, CLK: in std_logic; Q: out std_logic);
	end component;
	
	component slowclock is
		port (reset, fast : in std_logic; slow: out std_logic);
	end component;
	
	signal ns,s : std_logic_vector(1 downto 0);
	signal clk : std_logic;
	
begin 
cnt_0: slowclock port map(reset=>reset, fast=>clk_5M, slow=>clk);

--Resetting the FSM
--s(0)<='0'
--s(1)<='0'
--dff_rst0: DFlipFlop port map(reset=>'1' , D=>'0' , CLK=>clk, Q=>s(0));
--dff_rst1: DFlipFlop port map(reset=>'1' , D=>'0' , CLK=>clk, Q=>s(0));

ns(0) <= x;
ns(1) <= ( (x and s(0)) or (x and s(1)) or (s(1) and s(0)) );

y <= ns(1);

dff_s0: DFlipFlop port map(reset=>reset, D=>ns(0) , CLK=>clk, Q=>s(0));
dff_s1: DFlipFlop port map(reset=>reset, D=>ns(1) , CLK=>clk, Q=>s(1));
end behave;