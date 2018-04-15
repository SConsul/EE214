library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReactionGame is
  port (reset, start, CLK, react, : in std_logic;
  		react_time: out unsigned (15 downto 0) );
end entity;

architecture react of ReactionGame is
	
	component debouncer is
		port(reset, x, clk_5M : in std_logic; 
		y : out std_logic);
	end component;

	component del_Randomizer is
	  port (	reset, start, react, CLK: in std_logic; 
				del: out unsigned (7 downto 0) );
	end component;
	
	component slowto128 is
		port (reset, CLK: in std_logic; Q: out std_logic);
	end component;

	component del_countdown is
	  port (reset, CLK, in_start: in std_logic;
			--in_count: in unsigned (7 downto 0);
			done: out std_logic);
	end component;
	
	component interval_countup is
	  port (reset, CLK, start_game, start_count, 
				react, had_failed, LED_on : in std_logic;
			rtime: out unsigned (15 downto 0);
			fail_out: out std_logic);
	end component;

	signal LED_on, user_react, game_start, hard_reset, clock128, rand_del: std_logic;
begin
	user_react<= not react;
	game_start<= not start;
	hard_reset<= not reset;
	rand: del_Randomizer(hard_reset, game_start, user_react, CLK, rand_del);
	slow1: slowto128 port map(hard_reset, CLK, clock128);
		
end react;
