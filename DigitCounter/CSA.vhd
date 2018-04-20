library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

entity CSA is
   port(x0,x1,x2: in std_logic;
        s,cout: out std_logic);
end entity;
architecture Struct of CSA is
   component XOR_2 is
	port (a, b: in std_logic; c : out std_logic);
   end component;

	component AND_2 is
	port (a, b: in std_logic; c : out std_logic);
   end component;
	
   component OR_2 is
	port (a, b: in std_logic; c : out std_logic);
   end component;
   
	signal xor_s1, a1,a2,a3, o1: std_logic;
begin
   x_1: XOR_2 port map (a => x0, b => x1, c => xor_s1);
   

   x_2: XOR_2 port map (a => xor_s1, b => x2, c => s);

   a_1: AND_2 port map (a => x0, b => x1, c => a1);
   a_2: AND_2 port map (a => x1, b => x2, c => a2);
   a_3: AND_2 port map (a => x2, b => x0, c => a3);
  
   o_1: OR_2 port map (a => a1, b => a2, c => o1);
   o_2: OR_2 port map (a => o1, b => a3, c => cout);


end Struct;
