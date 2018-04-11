library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity knife is
port(rst,clk : in std_logic; 
		x : in std_logic_vector(4 downto 0);
		y : out std_logic);
end entity;
architecture behave of knife is
	component DFlipFlop is
		port (D, CLK: in std_logic; Q: out std_logic);
	end component;
	component isLetter is
		port(ref, test : in std_logic_vector(4 downto 0);
				ans : out std_logic);
	end component;
	signal ns, s : std_logic_vector(2 downto 0);
	signal isK, isN, isI, isF, isE  : std_logic;
	
begin
--Input
--K is 11:01011
--N is 14:01110  
--I is 9 :01001 
--F is 6 :00110  
--E is 5 :00101 

isKL_0: isLetter port map (ref=>"01011" , test=>x , ans=>isK);
isKL_1: isLetter port map (ref=>"01110" , test=>x , ans=>isN);
isKL_2: isLetter port map (ref=>"01001" , test=>x , ans=>isI);
isKL_3: isLetter port map (ref=>"00110" , test=>x , ans=>isF);
isKL_4: isLetter port map (ref=>"00101" , test=>x , ans=>isE);


--States
--000 Null
--001 K
--010 KN 
--011 KNI
--100 KNIF

ns(0) <= (( isK and (not s(2)) and (not s(1)) and (not s(0)) ) 
			or ( (not isN) and (not s(2)) and (not s(1)) and s(0) )
			or ( isI and (not s(2)) and s(1) and (not s(0)) )
			or ((not isF) and (not s(2)) and s(1) and s(0) )) and (not rst);
			
ns(1) <= ((isN and (not s(2)) and (not s(1)) and s(0) ) 
			or ( (not s(2)) and s(1) and (not s(0)) )
			or ( (not isF) and (not s(2)) and s(1) and s(0) )) and (not rst);

ns(2) <= (((not isE) and s(2) and (not s(1)) and (not s(0)) )
			or (isF and (not s(2)) and s(1) and s(0) )) and (not rst);
			
y <= isE and s(2) and (not s(1)) and (not s(0)) and (not rst);

dff_k0: DFlipFlop port map(D=>ns(0) , CLK=>clk, Q=>s(0));
dff_k1: DFlipFlop port map(D=>ns(1) , CLK=>clk, Q=>s(1));
dff_k2: DFlipFlop port map(D=>ns(2) , CLK=>clk, Q=>s(2));
end behave;
