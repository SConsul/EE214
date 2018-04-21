library std ;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slowto1000 is
port(reset, fast_clk : in std_logic; 
		slow_clk : out std_logic);
end entity slowto1000;
architecture behave of slowto1000 is

	type sl_RTLState is (zero, one);
	signal sl_rtl_state: sl_RTLState;
	signal slow_clk_sig : std_logic;
	signal sl_count: unsigned (14 downto 0);
	constant nill: unsigned (14 downto 0):= (others => '0') ;
		
begin
	slow_clk<=slow_clk_sig;
	process(reset,fast_clk, slow_clk_sig, sl_rtl_state, sl_count)
		variable next_sl_rtl_state:sl_RTLState;
		variable sl_count_var: unsigned (14 downto 0);
		variable slow_clk_var:std_logic;
		--25k = 0b110000110101000
		begin
			slow_clk_var:=slow_clk_sig;
			next_sl_rtl_state:=sl_rtl_state;
			sl_count_var:=sl_count;
			
			case sl_rtl_state is
				when zero=>
					slow_clk_var:='0';
					if(sl_count_var=24999) then 
						next_sl_rtl_state:=one;
						sl_count_var:=nill;
					else
						sl_count_var:=sl_count_var+1;
					end if;
					
				when one=>
					slow_clk_var:='1';
					if(sl_count_var=24999) then
						next_sl_rtl_state:=zero;
						sl_count_var:=nill;
					else
						sl_count_var:=sl_count_var+1;
					end if;
			end case;
			
			if(rising_edge(fast_clk)) then
				if(reset='1') then
					sl_rtl_state<=zero;
					sl_count<=nill;
				else
					sl_rtl_state<=next_sl_rtl_state;
					sl_count<=sl_count_var;
					slow_clk_sig<= slow_clk_var;
			end if;
		end if;
	end process;
end behave;
