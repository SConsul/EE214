-- A DUT entity is used to wrap your design.

library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
   port(input_vector: in std_logic_vector(6 downto 0);
	output_vector: out std_logic_vector(0 downto 0));
end entity;

architecture DutWrap of DUT is

component SRecognizer is 
	port(RST, CLK : in std_logic; X : in std_logic_vector(4 downto 0);  Y : out std_logic);
end component;	

begin
dut: SRecognizer port map(RST => input_vector(6), CLK => input_vector(5),  X => input_vector(4 downto 0), Y => output_vector(0));
end DutWrap;
