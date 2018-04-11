library  std ;
use  std.standard.all; library ieee;
use ieee.std_logic_1164.all;

entity mux_8 is
	port (ip0, ip1 : in std_logic_vector (7 downto 0);
			s :in std_logic;
			op : out std_logic_vector (7 downto 0)	);
end entity;
architecture  Behave of mux_8 is
begin
	op(0)<=(ip0(0) and (not s)) or (ip1(0) and s);
	op(1)<=(ip0(1) and (not s)) or (ip1(1) and s);
	op(2)<=(ip0(2) and (not s)) or (ip1(2) and s);
	op(3)<=(ip0(3) and (not s)) or (ip1(3) and s);
	op(4)<=(ip0(4) and (not s)) or (ip1(4) and s);
	op(5)<=(ip0(5) and (not s)) or (ip1(5) and s);
	op(6)<=(ip0(6) and (not s)) or (ip1(6) and s);
	op(7)<=(ip0(7) and (not s)) or (ip1(7) and s);
end Behave;