--interval_countup is a count up (16 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interval_countup is
  port (CLK, reset, start_game, react, start_cu_count, had_failed, LED_on : in std_logic;
  		rtime: out unsigned (15 downto 0);
  		fail_out: out std_logic);
end entity;

architecture countup of interval_countup is
	type cu_RTLState is (cu_rst, cu_incr, cu_fail);
	signal cu_rtl_state: cu_RTLState;
	signal failure: std_logic;
	signal cu_count: unsigned (15 downto 0);
	constant Z15 : unsigned (15 downto 0) := (others => '0');
	--Timeout of ~4s 000000100.0000000
	constant T15 : unsigned (15 downto 0) := (9=>'1', others => '0');
	
begin
	
	process (CLK, reset, start_game, start_cu_count, react, cu_rtl_state, LED_on, failure)
		variable next_cu_rtl_state: cu_RTLState;
		variable next_cu_count_var: unsigned (15 downto 0);
		variable rtime_var: unsigned (15 downto 0);
		variable fail_var: std_logic;
		variable single: std_logic;
		variable timeout_var: std_logic;
	begin
		single:='1';
		cu_fail_var := had_failed;
		next_cu_rtl_state:=rtl_state;
		next_cu_count_var := Z15;
		rtime_var :=(others =>'0');
		
		case cu_rtl_state is
			when cu_rst =>
				next_cu_count_var := Z15;
				if (start_cu_count ='1') then
					next_cu_rtl_state := cu_incr;
				end if;
			when cu_incr =>
				if (cu_count = T15) then
					next_cu_rtl_state := cu_fail;
				else
					next_cu_count_var := (next_cu_count_var+1);
					if rising_edge(react) then
						if (single ='0') then 
							next_cu_rtl_state := cu_fail;
						else
							single:='0';
							if (LED_on = '1') then
								rtime_var:=next_cu_count_var;
								rtime<=rtime_var;
							else 
								next_cu_rtl_state := cu_fail;
							end if;
						end if;
					end if;
				end if;
			when cu_fail =>	
				cu_fail_var:='1';
				rtime_var :=(others =>'0');
		end case;
			


		if rising_edge(CLK) then
			fail_out<=cu_fail_var or failure or had_failed;
			failure<=cu_fail_var or failure or had_failed;
			if(had_failed = '1') then
				cu_rtl_state <=cu_fail;
			elsif (reset ='1' or start_game='1') then
				cu_rtl_state <= cu_rst;
			else
				cu_rtl_state <=next_cu_rtl_state;
				cu_count <= next_cu_count_var;
			end if;
		end if;
	end process;
end countup;