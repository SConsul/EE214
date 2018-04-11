library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity gun is
port(rst,clk : in std_logic; 
		x : in std_logic_vector(4 downto 0);
		y : out std_logic);
end entity;
architecture behave of gun is
	component DFlipFlop is
		port (D, CLK: in std_logic; Q: out std_logic);
	end component;
	component isLetter is
		port(ref, test : in std_logic_vector(4 downto 0);
				ans : out std_logic);
	end component;
	signal ns, s : std_logic_vector(1 downto 0);
	signal isG, isU, isN  : std_logic;
begin
--Inputs			--States
--G is 7 :00111		--00 Null
--U is 21:10101  	--01 G
--N is 14:01110		--10 GU 

isGL_0: isLetter port map (ref=>"00111" , test=>x , ans=>isG);
isGL_1: isLetter port map (ref=>"10101" , test=>x , ans=>isU);
isGL_2: isLetter port map (ref=>"01110" , test=>x , ans=>isN);

ns(0) <= ( (isG and (not s(1))) or ((not isU) and s(0)) ) and (not rst);

ns(1) <=  ( (isU and s(0)) or ((not isN) and s(1)) ) and (not rst);
y <= isN and s(1) and (not s(0)) and (not rst);

dff_g0: DFlipFlop port map(D=>ns(0) , CLK=>clk, Q=>s(0));
dff_g1: DFlipFlop port map(D=>ns(1) , CLK=>clk, Q=>s(1));
end behave;
