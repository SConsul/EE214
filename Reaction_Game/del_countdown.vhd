--del_countdown is a count down (8 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity del_countdown is
  port (reset, CLK, in_start: in std_logic;
  		--in_count: in unsigned (7 downto 0);
  		done: out std_logic);
end entity del_countdown;

architecture cntdown of del_countdown is
	component slowto128 is
		port (reset, CLK: in std_logic; Q: out std_logic);
	end component;
	
	type RTLState is (rst, decr);
	signal slowed_clk: std_logic;
	signal rtl_state: RTLState;
	--signal done: std_logic;
	signal start: std_logic;
	signal count: unsigned (7 downto 0);
	constant Z8 : unsigned (7 downto 0) := (others => '0');
	
begin
	--count <= in_count;
	start <= in_start;
	slow1: slowto128 port map(reset, CLK, slowed_clk);
	process (slowed_clk, reset, start, count, rtl_state)
		variable next_rtl_state: RTLState;
		variable next_count_var: unsigned (7 downto 0);
		variable done_var: std_logic;
	begin
		next_rtl_state:=rtl_state;
		next_count_var := count;
		done_var := '0';
		
		case rtl_state is
			when rst =>
				if (start ='1') then
					next_rtl_state := decr;
					next_count_var := count;
				end if;
			when decr =>
				if (count = Z8) then
					next_rtl_state := rst;
					done_var :='1';
				else
					next_count_var := (next_count_var-1);
				end if;
		end case;
		done <= done_var;
		
		if (slowed_clk'event and slowed_clk = '1') then
			if (reset = '1') then
				rtl_state <= rst;
			else
				rtl_state <=next_rtl_state;
			end if;
			count <= next_count_var;
		end if;
	end process;
end cntdown;