-- USE CLOCK BETWEEN 100 HZ TO 10K

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
entity final_test1 is
port (clk    : in std_logic;                          --use clock between 100hz to 10khz 
      rst    : in std_logic;	--reset
      lcd_rw : out std_logic;                         --read & write control
      lcd_en : out std_logic;                         --enable control
      lcd_rs : out std_logic;                         --data or command control
      lcd1  : out std_logic_vector(7 downto 0);		 --see pin planning in krypton manual 
		b11 : out std_logic;
		b12 : out std_logic;
		s : in std_logic);     --data line
end final_test1;

architecture behave of final_test1 is 


component lcd_controller is
port ( clk    : in std_logic;                          --clock i/p
       rst    : in std_logic;                          -- reset
	   erase : in std_logic;                  --- clear position
	   put_char : in std_logic;
	   write_data : in std_logic_vector(7 downto 0) ;
		write_row : in std_logic_vector(0 downto 0);
		write_column : in std_logic_vector(3 downto 0);
	   ack : out std_logic;
      lcd_rw : out std_logic;                         --read & write control
      lcd_en : out std_logic;                         --enable control
      lcd_rs : out std_logic;                         --data or command control
      lcd1  : out std_logic_vector(7 downto 0);
		b11 : out std_logic;
		b12 : out std_logic);     --data line
end component lcd_controller;

component clock_converter is
port(clk : in std_logic; SPI_clk : out std_logic);
end component clock_converter;


type dataarr1 is array (0 to 31) of std_logic_vector(7 downto 0);

--arrayfor displaying abcd... in asciii
 constant lcd_data1 : dataarr1 := (x"41",x"42",x"43",x"44",x"45",x"46",x"47",x"48",x"49",x"4a",x"4b",x"4c",x"4d",x"4e",x"4f",
			 x"50",x"51",x"52",x"53",x"54",x"55",x"56",x"57",x"58",x"59",x"5a",x"30",x"31",x"32",x"33",x"34",x"35");  
 
 
 
signal erase : std_logic := '0';                  --- clear position
signal put_char :  std_logic := '1';
  --write_data : in std_logic_vector(7 downto 0) ;
signal 		write_row : std_logic_vector( 0 downto 0) := "0";
signal write_column : std_logic_vector(3 downto 0) := "0000";

signal clock_slow : std_logic; 
signal s1,s11 : std_logic_vector ( 3 downto 0) := "0000"; -- S1 IS WRITE_COLUMN
signal i,j : integer := 0; 
signal ack,o2: std_logic;
begin
-- HOW TO USE LCD CONTROLLER MODULE
lcd_instance1 : lcd_controller port map (
					clk => clock_slow, rst => rst, erase => erase , put_char => put_char , write_data => lcd_data1(i), write_row => write_row,
					write_column => s1 , ack => ack, lcd_rw => lcd_rw, lcd_en => lcd_en, lcd_rs => lcd_rs,
					lcd1 => lcd1, b11 => b11, b12 => b12);	
					
clock_instance : clock_converter port map ( clk => clk , SPI_clk => clock_slow);

--		data1 <= lcd_data1(i);
--		put_char <= '1';
process(ack,rst,clock_slow)
begin

if (rising_edge(clock_slow)) then
	
if (rst = '0') then
	i <=0;
	erase <= '0';
	write_row <= "0";
	s1 <= "0000";
	put_char <= '1';
end if;
if(ack = '1') then 
--if (i =31) then i <= 0;
--else
	if ( i = 31 ) then
		i <= 0;
		erase <= not (erase);
		write_row <= "0";
		put_char <= not (put_char);
		s1 <= "0000";
	elsif (i = 15) then
		i <= i + 1;
		s1 <= "0000";
		put_char <= '1';
		write_row <= "1";
	elsif (i < 15) then
		i <=  i + 1;
		s1 <= s1 + 1;
		put_char <= '1';
		write_row <= "0";
	elsif (i> 15 and i<31) then
		i <=  i + 1;
		s1 <= s1 + 1;
		put_char <= '1';
		write_row <= "1";
		--write_column <= write_column + 1;
end if;
end if;
end if;
--		write_column <= write_column + 1;
----		if (write_column = "1111") then
----			write_row <= write_row + 1;
----		end if;
--	--elsif (ack = '0') then
--		--put_char <= '0';
--		--i <= i;
--		--write_column <= write_column;
--		--write_row <= write_row;
--	--end if;
--end if;
end process;



end architecture;