-- Logical Left Shifter

library  std ;
use  std.standard.all; library ieee;
use ieee.std_logic_1164.all;

entity leftshift is
	port (x,y : in std_logic_vector (7 downto 0);
			z : out std_logic_vector (7 downto 0)	);
end entity;
architecture  Behave of leftshift is
component mux_8 is
	port (ip0, ip1 : in std_logic_vector (7 downto 0);
			s :in std_logic;
			op : out std_logic_vector (7 downto 0)	);
end component mux_8;
signal s2, s1, s0 : std_logic_vector (7 downto 0);
	signal full_shift : std_logic;
begin
	full_shift <= y(7) or y(6) or y(5) or y(4) or y(3); 
	m2: mux_8 port map (ip0=>x, ip1(3 downto 0)=> "0000", ip1(7 downto 4) => x(3 downto 0), s=>y(2), op=>s2);
	m1: mux_8 port map (ip0=>s2, ip1(1 downto 0)=> "00", ip1(7 downto 2) => s2(5 downto 0), s=>y(1), op=>s1);
	m0: mux_8 port map (ip0=>s1, ip1(0)=>'0', ip1(7 downto 1) => s1(6 downto 0), s=>y(0), op=>s0);
	m_sel: mux_8 port map (ip0=>s0, ip1=>"00000000", s=>full_shift, op=>z);
end Behave;