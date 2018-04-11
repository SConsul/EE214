library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity bomb is
port(rst,clk : in std_logic; 
		x : in std_logic_vector(4 downto 0);
		y : out std_logic);
end entity;
architecture behave of bomb is
	component DFlipFlop is
		port (D, CLK: in std_logic; Q: out std_logic);
	end component;
	component isLetter is
		port(ref, test : in std_logic_vector(4 downto 0);
				ans : out std_logic);
	end component;
	signal ns, s : std_logic_vector(1 downto 0);
	signal isB, isO, isM  : std_logic;
	
begin
--Input
--B is 2: 00010
--O is 15:01111  
--M is 13:01101 

--States
--00 Null
--01 B
--10 BO 
--11 BOM
isBL_0: isLetter port map (ref=>"00010" , test=>x , ans=>isB);
isBL_1: isLetter port map (ref=>"01111" , test=>x , ans=>isO);
isBL_2: isLetter port map (ref=>"01101" , test=>x , ans=>isM);

--ns(0) <= ((isB and (not s(0)) and (not s(1)) ) or ( (not isO) and (not s(1)) and s(0) ) 
--		or (isM and s(1) and (not s(0)) ) or (isB and s(1) and s(0)) )V);

ns(0) <= ( ((not s(1)) and isB) or (s(0) and s(1) and (not isB)) or (s(1) and isM) or ((not isB) and (not isO) and s(0)) ) and (not rst);

--ns(1) <= (isO and (not s(1)) and s(0)) or (s(1) and (not s(0))) or ( (not isB) and s(1) and s(0) );
ns(1) <= ((isO and s(0)) or (s(1) and (not s(0))) or ((not isB) and s(1)) ) and (not rst);
y <= isB and s(1) and s(0) and (not rst);

dff_b0: DFlipFlop port map(D=>ns(0) , CLK=>clk, Q=>s(0));
dff_b1: DFlipFlop port map(D=>ns(1) , CLK=>clk, Q=>s(1));
end behave;
