library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity terror is
port(rst,clk : in std_logic; 
		x : in std_logic_vector(4 downto 0);
		y : out std_logic);
end entity;
architecture behave of terror is
	component DFlipFlop is
		port (D, CLK: in std_logic; Q: out std_logic);
	end component;
	component isLetter is
		port(ref, test : in std_logic_vector(4 downto 0);
				ans : out std_logic);
	end component;
	signal ns, s : std_logic_vector(4 downto 0);
	signal isT, isE, isR, isO : std_logic;
	
begin
--Input
--T is 20:10100
--E is 5 :00101 
--R is 18:10010  
--O is 15:01111 


isTL_0: isLetter port map (ref=>"10100" , test=>x , ans=>isT);
isTL_1: isLetter port map (ref=>"00101" , test=>x , ans=>isE);
isTL_2: isLetter port map (ref=>"10010" , test=>x , ans=>isR);
isTL_3: isLetter port map (ref=>"01111" , test=>x , ans=>isO);


--States
--00000 Null
--00001 T
--00010 TE 
--00100 TER
--01000 TERR
--10000 TERRO

ns(0) <= ( ((isT and not s(0)) or (not isE and s(0))) and not s(4) and not s(3) and not s(2) and not s(1) and not rst  );
			
ns(1) <= (  ( (isE and s(0) and not s(1)) or (not isR and s(1) and not s(0)) ) and not s(4) and not s(3) and not s(2) and not rst  );

ns(2) <= (  ( (isR and s(1) and not s(2)) or (not isR and s(2) and not s(1)) ) and not s(4) and not s(3) and not s(0) and not rst  );

ns(3) <= (  ( (isR and s(2) and not s(3)) or (not isO and s(3) and not s(2)) ) and not s(4) and not s(1) and not s(0) and not rst  );

ns(4) <= (  ( (isO and s(3) and not s(4)) or (not isR and s(4) and not s(3)) ) and not s(2) and not s(1) and not s(0) and not rst  );
			
y <= ( isR  and s(4) and not s(3) and not s(2) and not s(1) and not s(0) and not rst );

dff_t0: DFlipFlop port map(D=>ns(0) , CLK=>clk, Q=>s(0));
dff_t1: DFlipFlop port map(D=>ns(1) , CLK=>clk, Q=>s(1));
dff_t2: DFlipFlop port map(D=>ns(2) , CLK=>clk, Q=>s(2));
dff_t3: DFlipFlop port map(D=>ns(3) , CLK=>clk, Q=>s(3));
dff_t4: DFlipFlop port map(D=>ns(4) , CLK=>clk, Q=>s(4));

end behave;
