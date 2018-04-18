library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReactionGame is
  port (nreset, game_start, CLK, user_react : in std_logic);
end entity;

architecture react of ReactionGame is
	
	component slowto1000 is
		port (reset, CLK_50M: in std_logic; CLK_1k: out std_logic);
	end component;

	component debouncer is
		port(reset, x, clk_5M : in std_logic; 
		y : out std_logic);
	end component;

	component del_Randomizer is
	 port (CLK, reset, start, react: in std_logic; 
			del: out unsigned (7 downto 0) );
	end component;
		
	component slowto128 is
		port (reset, CLK_50M: in std_logic; CLK_128: out std_logic);
	end component;

	component del_countdown is
		port (CLK, reset, cd_start: in std_logic;
  		cd_in_count: in unsigned (7 downto 0);
  		cd_done: out std_logic);
	end component;
	
	component interval_countup is
		port (CLK, reset, start_cu_count, stop_cu_count : in std_logic;
				rtime: out unsigned (13 downto 0);
				timeout: out std_logic);
	end component;

	signal reset, react, start, CLK_128, CLK_1k : std_logic;
	signal start_cd, done_cd, start_cu, stop_cu, timeout: std_logic;
	
	signal rand_del:unsigned(7 downto 0);
	signal react_time: unsigned (13 downto 0);
	signal n :unsigned(3 downto 0);
	signal score: std_logic_vector (13 downto 0);
	type RTLState is (rst, pre_LED, LED_react, fail);	
	signal rtl_state: RTLState;
	signal single :std_logic;
	signal LED: std_logic_vector(8 downto 1);
	signal failed:std_logic;

begin
	reset<= not nreset;
	dbnce_srt: debouncer port map(reset, game_start, CLK, start);
	dbnce_react: debouncer port map(reset, user_react, CLK, react);
	
	slow128: slowto128 port map(reset, CLK, CLK_128);
	slow1k: slowto1000 port map(reset, CLK, CLK_1k);
			
	rand: del_Randomizer port map(CLK, reset, start, react, rand_del);
	cd: del_countdown port map(CLK_128, reset, start_cd, rand_del, done_cd);
	cu: interval_countup port map(CLK_1k, reset, start_cu, stop_cu, react_time, timeout); 
		
	process(CLK, reset, start, react, done_cd, failed, score, timeout)
	
	variable rep :unsigned(3 downto 0);
	variable score_var: unsigned(13 downto 0);
	variable next_rtl_state: RTLState;
	variable single_press: std_logic;
	variable cd_start_var: std_logic;
	variable cu_start_var: std_logic;
	variable cu_stop_var: std_logic;
	variable LED_var:std_logic_vector(8 downto 1);
	variable fail_var: std_logic;
	begin		
		--Initializing the variables
		rep:=n;
		score_var:=unsigned(score);
		next_rtl_state:=rtl_state;
		single_press:=single;
		cd_start_var:=start_cd;
		cu_start_var:=start_cu;
		cu_stop_var:=stop_cu;
		LED_var:=LED;
		fail_var:=failed;
		
		case rtl_state is
			when rst=>
				rep:=(others=>'0');
				score_var:=(others=>'0');
				fail_var:='0';
				single_press:='0';
				cd_start_var:='0';
				cu_start_var:='0';
				cu_stop_var:='0';
				LED_var:=(others=>'0');
				cd_start_var:='0';
				
				if (start ='1') then
					next_rtl_state:=pre_LED;
				end if;
				
			when pre_LED=>
				LED_var:=(others=>'0');
				if(fail_var='0' and react='0') then
					cd_start_var:='1';
					if(done_cd='1') then
						next_rtl_state:=LED_react;
						cu_start_var:='1';
						single_press:='1';
						LED_var(1):='1';
					end if;	
				else
					next_rtl_state:=fail;
				end if;
				
			when LED_react=>
				if(rep<"1000") then
					rep:=rep+1;
					cu_start_var:='0';
					if(timeout='1') then
						next_rtl_state:=fail;
					else
						if(react='1') then
							if(single_press='0') then
								next_rtl_state:=fail;
							else
								cu_stop_var:='1';
								single_press:='0';
								score_var:=unsigned(score_var)+react_time;
								next_rtl_state:=pre_LED;
							end if;
						end if;
					end if;
				else
					next_rtl_state:=rst;
				end if;
			when fail=>
				LED_var:=(others=>'1');
				score_var:=(others=>'0');
				if(reset='1' or start='1') then
					next_rtl_state:=rst;
				end if;
		end case;
		
		if(rising_edge(CLK)) then
			if (reset = '1') then
				rtl_state <= rst;
			else
				n<=rep;
				score<=std_logic_vector(score_var);
				rtl_state <=next_rtl_state;
				single<=single_press;
				start_cd<=cd_start_var;
				start_cu<=cu_start_var;
				stop_cu<=cu_stop_var;
				LED<=LED_var;
				failed<=fail_var;
			end if;
		end if;
		
	end process;
end react;
