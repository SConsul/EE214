--del_countdown is a count down (8 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity del_countdown is
  port (CLK, reset, cd_start: in std_logic;
  		cd_in_count: in unsigned (7 downto 0);
  		cd_done: out std_logic);
end entity del_countdown;

architecture cntdown of del_countdown is
	component slowto128 is
		port (reset, CLK_50M: in std_logic; CLK_128: out std_logic);
	end component;
	
	type cd_RTLState is (cd_rst, cd_decr);
	signal slowed_clk: std_logic;
	signal cd_rtl_state: cd_RTLState;
	signal cd_count: unsigned (7 downto 0);
	constant Z8 : unsigned (7 downto 0) := (others => '0');
	
begin
	slow1: slowto128 port map(reset, CLK, slowed_clk);
	process (slowed_clk, reset, cd_start, cd_count, cd_rtl_state)
		variable next_cd_rtl_state: cd_RTLState;
		variable cd_count_var: unsigned (7 downto 0);
		variable cd_done_var: std_logic;
	begin
		next_cd_rtl_state:=cd_rtl_state;
		cd_count_var := cd_count;
		cd_done_var := '0';
		
		case cd_rtl_state is
			when cd_rst =>
				cd_count_var := cd_in_count;
				if (cd_start ='1') then
					next_cd_rtl_state := cd_decr;
				end if;
			when cd_decr =>
				if (cd_count = Z8) then
					next_cd_rtl_state := cd_rst;
					cd_done_var :='1';
				else
					cd_count_var := (cd_count_var-1);
				end if;
		end case;
		cd_done <= cd_done_var;
		
		if (slowed_clk'event and slowed_clk = '1') then
			if (reset = '1') then
				cd_rtl_state <= cd_rst;
			else
				cd_rtl_state <=next_cd_rtl_state;
			end if;
			cd_count <= cd_count_var;
		end if;
	end process;
end cntdown;