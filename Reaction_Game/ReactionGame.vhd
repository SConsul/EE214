library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReactionGame is
  port (nreset, ngame_start, CLK, nuser_react : in std_logic;
				LED_out: out std_logic_vector(8 downto 1));
end entity;

architecture react of ReactionGame is
	
	component slowto1000 is --Slows 50MHz Clock to 1kHz
		port(reset, fast_clk : in std_logic; slow_clk : out std_logic);
	end component;
	
	component db_slowclock is --Slows 50MHz Clock ~ 100Hz
		port (reset, fast : in std_logic; slow: out std_logic);
	end component;
	
	component debouncer is --Debounces signal from switches
		port(reset, x, clk: in std_logic; y : out std_logic);
	end component;
	
	component del_Randomizer is --Generates random no. between 1000 and 1999
	 port (CLK, reset, start, react: in std_logic; 
			del: out unsigned (10 downto 0) );
	end component;

	component del_countdown is --Counts down rand_del at 1kHz (takes 1-2s)
		port (CLK, reset, cd_start: in std_logic;
  		cd_in_count: in unsigned (10 downto 0);
  		cd_done: out std_logic);
	end component;
	
	component interval_countup is --Counts delay till reaction (reaction time)
		port (CLK, reset, start_cu_count, stop_cu_count : in std_logic;
				rtime: out unsigned (15 downto 0);
				timeout: out std_logic);
	end component;

	signal reset, user_react, react, game_start, start, CLK_1k, CLK_db : std_logic;
	signal start_cd, done_cd, start_cu, stop_cu, timeout: std_logic;

	signal rand_del:unsigned(10 downto 0);
	signal react_time, score : unsigned (15 downto 0);
	signal n :unsigned(3 downto 0);
	type RTLState is (rst, pre_LED, LED_react, hold, fail);	
	signal rtl_state: RTLState;
	signal LED: std_logic_vector(8 downto 1);
	signal hold_c_sig:unsigned(24 downto 0); --1111101000
begin
	LED_out<=LED;
	--Switches are high without pressing
	reset<= not nreset; 
	game_start<= not ngame_start;
	user_react<= not nuser_react;
	slow_db: db_slowclock port map(reset, CLK, CLK_db);
	slow1k: slowto1000 port map(reset, CLK, CLK_1k);

	dbnce_srt: debouncer port map(reset, game_start, CLK_db, start);
	dbnce_react: debouncer port map(reset, user_react, CLK_db, react);
			
	rand: del_Randomizer port map(CLK, reset, start, react, rand_del);
	cd: del_countdown port map(CLK_1k, reset, start_cd, rand_del, done_cd);
	cu: interval_countup  port map(CLK_1k, reset, start_cu, stop_cu, react_time, timeout); 

	process(CLK, reset, start, react, rtl_state,	score, start_cd,
				done_cd, start_cu, stop_cu, timeout, react_time, n, LED, hold_c_sig)
	
	variable rep :unsigned(3 downto 0);
	variable score_var: unsigned(15 downto 0);
	variable next_rtl_state: RTLState;
	variable cd_start_var: std_logic;
	variable cu_start_var: std_logic;
	variable cu_stop_var: std_logic;
	variable LED_var:std_logic_vector(8 downto 1);
	variable hold_c_var:unsigned(24 downto 0);
	
	begin		
		--Initializing the variables to corresponding signals
		rep:=n;
		score_var:=score;
		next_rtl_state:=rtl_state;
		cd_start_var:=start_cd;
		cu_start_var:=start_cu;
		cu_stop_var:=stop_cu;
		LED_var:=LED;
		hold_c_var:=hold_c_sig;
		
		case rtl_state is
			when rst=> --reset state
				rep:=(others=>'0');
				score_var:=(others=>'0');
				cd_start_var:='0';
				cu_start_var:='0';
				cu_stop_var:='0';
				LED_var:=(2=>'1', 4=>'1', 6=>'1', 8=>'1', others=>'0');
				hold_c_var:=(others=>'0');
				
				if (start ='1') then
					next_rtl_state:=pre_LED;
					LED_var:=(7=>'1', 8=>'1', others=>'0');
				end if;
				
			when pre_LED=> --waiting for random delay before switching on test LED
				hold_c_var:=(others=>'0');
				cd_start_var:='1'; 
				
				if(react='1') then --reacting when test LED is off is a violation-> FAIL
					next_rtl_state:=fail;
				elsif(done_cd='1') then --Random interval between 1 to 2 s is over
					next_rtl_state:=LED_react;
					rep:=rep+1;
					cd_start_var:='0'; 
					cu_stop_var:='0';
					cu_start_var:='1';
					LED_var:=(1=>'1', others=>'0');
				end if;	
				
			when LED_react=> --State when test LED is on and reaction time is measured
				if(rep/=9) then --game runs 8 times
					if(timeout='1') then --Timeout of 2s (user took too long)
						next_rtl_state:= fail;
					elsif(react='1') then
							cu_stop_var:='1';
							cu_start_var:='0';	
							next_rtl_state:= hold;
							LED_var:=(5=>'1', others=>'0');
					end if;
				else
					next_rtl_state:=rst;
				end if;
				
			when hold=> --Intermediate state to ensure avoid false double react failure (as switches are slower than 50MHz)
			
				hold_c_var:=hold_c_sig + 1;
				if(hold_c_var=125000) then --2.5ms
					score_var:=score_var + react_time;
					LED_var:=(3=>'1', others=>'0');
					
				elsif(hold_c_var=25000000) then	--25 000 000 = 0b1011111010111100001000000
															--0.5s gap for switch to be released (*) 
					next_rtl_state:= pre_LED;
					LED_var:=(7=>'1', 8=>'1', others=>'0');
					cu_stop_var:='0';
					hold_c_var:=(others=>'0');
				end if;
				
			when fail=>--User has failed, wait for reset or start to exit
				LED_var:=(others=>'0');
				score_var:=(others=>'0');
				if(reset='1' or start='1') then
					next_rtl_state:=rst;
				end if;
		end case;
		
		if(rising_edge(CLK)) then --updating signals at CLK's rising edge
			n<=rep;
			score<=score_var;
			start_cd<=cd_start_var;
			start_cu<=cu_start_var;
			stop_cu<=cu_stop_var;
			hold_c_sig<=hold_c_var;
			LED<=LED_var;
			if (reset = '1') then
				rtl_state <= rst;
			else
				rtl_state <=next_rtl_state;	
			end if;
		end if;
		
	end process;
end react;
