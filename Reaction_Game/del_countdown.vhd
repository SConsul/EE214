--del_countdown is a count down (10 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity del_countdown is
  port (CLK, reset, cd_start: in std_logic;
  		cd_in_count: in unsigned (10 downto 0);
  		cd_done: out std_logic);
end entity del_countdown;

architecture cntdown of del_countdown is
	
	type cd_RTLState is (cd_rst, cd_decr);
	signal cd_done_sig: std_logic;
	signal cd_rtl_state: cd_RTLState;
	signal cd_count: unsigned (10 downto 0);
	constant Z8 : unsigned (10 downto 0) := (others => '0');
	
begin
	cd_done<=cd_done_sig;

	process (CLK, reset, cd_start, cd_in_count, cd_count, cd_rtl_state, cd_done_sig)
		variable next_cd_rtl_state: cd_RTLState;
		variable cd_count_var: unsigned (10 downto 0);
		variable cd_done_var: std_logic;
	begin
		next_cd_rtl_state:=cd_rtl_state;
		cd_count_var := cd_count;
		cd_done_var:=cd_done_sig;
		
		case cd_rtl_state is
			when cd_rst =>
				cd_done_var := '0';
				cd_count_var := cd_in_count;
				if (cd_start ='1') then
					next_cd_rtl_state := cd_decr;
				end if;
			when cd_decr =>
				if (cd_count = 2) then
					next_cd_rtl_state := cd_rst;
					cd_done_var :='1';
				else
					cd_count_var := (cd_count-1);
				end if;
		end case;
		
		if (rising_edge(CLK)) then
			if (reset = '1') then
				cd_rtl_state <= cd_rst;
			else
				cd_rtl_state <=next_cd_rtl_state;
			end if;
			cd_count <= cd_count_var;
			cd_done_sig <= cd_done_var;
		end if;
	end process;
end cntdown;
