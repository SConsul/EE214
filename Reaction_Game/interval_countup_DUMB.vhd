--interval_countup is a count up (16 bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interval_countup is
  port (CLK, reset, start_cu_count, stop_cu_count : in std_logic;
  		rtime: out unsigned (13 downto 0);
  		timeout: out std_logic);
end entity;

architecture countup of interval_countup is
	type cu_RTLState is (cu_rst, cu_incr);
	signal cu_rtl_state: cu_RTLState;
	signal cu_count: unsigned (13 downto 0);
	constant Z : unsigned (13 downto 0) := (others => '0');
	--Timeout of ~2s = 00011111010000
				  --16s = 11111010000000
	constant T : unsigned (13 downto 0) := (0=>'0', 1=>'0', 2=>'0', 3=>'0', 5=>'0',
														11=>'0', 12=>'0', 13=>'0', others => '1');
	
begin
	
	process (CLK, reset, start_cu_count, stop_cu_count, cu_rtl_state)
		variable next_cu_rtl_state: cu_RTLState;
		variable next_cu_count_var: unsigned (13 downto 0);
		variable rtime_var: unsigned (13 downto 0);
		variable timeout_var: std_logic;
	begin
		next_cu_rtl_state:=cu_rtl_state;
		next_cu_count_var := Z;
		
		case cu_rtl_state is
			when cu_rst =>
				next_cu_count_var := Z;
				if (start_cu_count ='1') then
					next_cu_rtl_state := cu_incr;
					timeout_var:='0';
				end if;
			when cu_incr =>
				if (cu_count = T) then
					timeout_var:='1';
					next_cu_rtl_state := cu_rst;
				else
					next_cu_count_var := (next_cu_count_var+1);
					if (stop_cu_count='1') then
							rtime_var:=next_cu_count_var;
							next_cu_rtl_state := cu_rst;
					end if;
				end if;
		end case;
			
		if rising_edge(CLK) then
			if (reset ='1') then
				cu_rtl_state <= cu_rst;
			else
				cu_rtl_state <=next_cu_rtl_state;
				cu_count <= next_cu_count_var;
				timeout<=timeout_var;
				rtime<=rtime_var;
			end if;
		end if;
		
	end process;
end countup;