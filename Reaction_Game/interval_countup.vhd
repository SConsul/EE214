--interval_countup is a count up (16 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interval_countup is
  port (reset, CLK, start_game, start_count, react, had_failed, LED_on : in std_logic;
  		rtime: out unsigned (15 downto 0);
  		fail_out: out std_logic);
end entity;

architecture countup of interval_countup is
	type RTLState is (rst, incr, fail);
	signal rtl_state: RTLState;
	signal failure: std_logic;
	signal count: unsigned (15 downto 0);
	constant Z15 : unsigned (15 downto 0) := (others => '0');
	--Timeout of ~4s 000000100.0000000
	constant T15 : unsigned (15 downto 0) := (9=>'1', others => '0');
	
begin
	
	process (CLK, reset, start_game, start_count, react, rtl_state, LED_on, failure)
		variable next_rtl_state: RTLState;
		variable next_count_var: unsigned (15 downto 0);
		variable rtime_var: unsigned (15 downto 0);
		variable fail_var: std_logic;
		variable single: std_logic;
		variable timeout_var: std_logic;
	begin
		single:='1';
		fail_var := had_failed;
		next_rtl_state:=rtl_state;
		next_count_var := Z15;
		rtime_var :=(others =>'0');
		
		case rtl_state is
			when rst =>
				next_count_var := Z15;
				if (start_game ='1') then
					next_rtl_state := incr;
				end if;
			when incr =>
				if (count = T15) then
					next_rtl_state := fail;
				else
					next_count_var := (next_count_var+1);
					if rising_edge(react) then
						if (single ='0') then 
							next_rtl_state := fail;
						else
							single:='0';
							if (LED_on = '1') then
								rtime_var:=next_count_var;
								rtime<=rtime_var;
							else 
								next_rtl_state := fail;
							end if;
						end if;
					end if;
				end if;
			when fail =>	
				fail_var:='1';
				rtime_var :=(others =>'0');
		end case;
			


		if rising_edge(CLK) then
			fail_out<=fail_var or failure or had_failed;
			failure<=fail_var or failure or had_failed;
			if(had_failed = '1') then
				rtl_state <=fail;
			elsif (reset ='1' or start_count='1') then
				rtl_state <= rst;
			else
				rtl_state <=next_rtl_state;
				count <= next_count_var;
			end if;
		end if;
	end process;
end countup;