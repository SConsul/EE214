-----------------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------
entity SRecognizer is 
	port(RST, CLK : in std_logic; X : in std_logic_vector(4 downto 0);  Y : out std_logic);
end entity;

architecture behave of SRecognizer is 
	signal sig1,sig2,sig3,sig4 : std_logic;

	component bomb is
		port(rst,clk : in std_logic; 
			x : in std_logic_vector(4 downto 0);
			y : out std_logic);
	end component;

	component gun is
		port(rst,clk : in std_logic; 
			x : in std_logic_vector(4 downto 0);
			y : out std_logic);
	end component;

	component knife is
		port(rst,clk : in std_logic; 
			x : in std_logic_vector(4 downto 0);
			y : out std_logic);
	end component;
		
	component terror is
		port(rst,clk : in std_logic; 
			x : in std_logic_vector(4 downto 0);
			y : out std_logic);
	end component;	 
-----------------------------------------------			
begin 
a: bomb       port map(rst => RST, clk => CLK, x => X, y => sig1);
b: gun	     port map(rst => RST, clk => CLK, x => X, y => sig2);
c: knife      port map(rst => RST, clk => CLK, x => X, y => sig3);
d: terror	  port map(rst => RST, clk => CLK, x => X, y => sig4);
-----------------------------------------------
--sig1<='0';
--sig2<='0';
--sig3<='0';
Y <= sig1 or sig2 or sig3 or sig4;

end behave;