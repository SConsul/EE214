library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity react_time is
  port (reset, CLK, start, react, led_is_on: in std_logic;
  		rtime: out unsigned (15 downto 0);
  		timeout: out std_logic);
end entity;

architecture countup of react_time is
	type RTLState is {rst, incr};
	signal rtl_state: RTLState;
	signal start: std_logic;
	signal timeout: std_logic;
	signal count: unsigned (15 downto 0);
	signal n_react: std_logic;
	constant Z15 : unsigned (15 downto 0) := (others => '0');
	--Timeout of ~4s 000000100.0000000
	constant T15 : unsigned (15 downto 0) := " 0000001000000000";
	
begin
 
	process (reset, start, react, CLK, led_is_on)
		variable next_rtl_state_var: RTLState;
		variable next_count_var: unsigned (15 downto 0);
		variable rtime_var: unsigned (15 downto 0);
		variable timeout_var: std_logic;
		variable n_react_var:std_logic;
	begin
		next_rtl_state:=rtl_state;
		next_count_var := Z15;
		timeout_var := '0';
		rtime_var :=(others =>'0');
		n_react_var:='0';
		
		case rtl_state is
			when rst =>
				next_count_var := Z15;
				if (start ='1') then
					next_rtl_state := incr;
				end if;
			when incr =>
				if (count = T9) then
					next_rtl_state := rst;
					timeout_var :='1';
				else
					next_count_var := (next_count_var+1);
				end if;
		end case;
		
		if (CLK’event and (CLK=’1’)) then
			if(react'event) then
				n_react_var:='1';
				n_react<=n_react_var;
			end if;
			if (reset ='1') then
				rtl_state <= rst;
			elsif (react'event and ((led_is_on = '0') or (n_react=1)) then
				timeout_var:='1';
				rtl_state <= rst;	
			else
				rtl_state <=next_rtl_state;
				if (react = '1') then 
					rtime_var:=next_count_var;
					rtime<=rtime_var;
				end if;
			end if;
			count <= next_count_var;
			timeout<=timeout_var;
		end if;
	end process;
end countup;