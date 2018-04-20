-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  two-bit adder.
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
   port(input_vector: in std_logic_vector(7 downto 0);
       	output_vector: out std_logic_vector(3 downto 0));
end entity;

architecture DutWrap of DUT is		
component midsemcir is
	port( x : in std_logic_vector(7 downto 0); y : out std_logic_vector(3 downto 0));
end component;	

begin

dut: midsemcir port map( x => input_vector, y => output_vector);
end DutWrap;

