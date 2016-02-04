library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity LEDSTRIP is
port(	data_in:		in  	std_logic;
		clk_in: 		in 	std_logic;
		data_out:	out 	std_logic
);
end LEDSTRIP;

-------------------------------------------------

architecture behv of LEDSTRIP is
signal b1 : std_logic_vector(23 downto 0) := (others => '0');
signal s1 : std_logic_vector(23 downto 0) := (others => '0');
signal s2 : std_logic_vector(239 downto 0) := (others => '0');
signal output_en :std_logic := '0';
signal serial_en : std_logic := '0';
signal serial_out : std_logic_vector(7 downto 0) := (others => '0');
signal serial_done : std_logic := '0';
signal output_done : std_logic := '0';
signal clock : std_logic := '0';
signal write_buf : std_logic := '0';
signal buffer_empty : std_logic := '0';
signal buffer_full : std_logic := '0';
type STATES is (WAIT1,WAIT2,WAIT3,SEND,WRBUF,RELOAD,RELOAD1);
signal sm_state : STATES := WAIT1;

begin

process (clock)
begin
	if clock'event and clock = '1' then
		case sm_state is 
			when WAIT1 =>
				if buffer_full = '1' then
					sm_state <= SEND;
				else
					if serial_done = '1' then
						s1(23 downto 16) <= serial_out;
						if buffer_empty = '1' then
							sm_state <= WRBUF;
							write_buf <= '1';
						else
							sm_state <= WAIT2;
						end if;
					end if;
				end if;
			when WRBUF =>
				write_buf <= '0';
				sm_state <= WAIT1;
			when WAIT2 =>
				if serial_done = '1' then
					s1(15 downto 8) <= serial_out;
					sm_state <= WAIT3;
				end if;
			when WAIT3 =>
				if serial_done = '1' then
					s1(7 downto 0) <= serial_out;
					sm_state <= WRBUF;
					write_buf <= '1';
				end if;
			when SEND =>
				if output_done = '1' then
					if buffer_empty = '1' then
						sm_state <= WAIT1;
					else
						write_buf <= '1';
						sm_state <= RELOAD;
					end if;
				end if;
			when RELOAD =>
				write_buf <= '0';
				sm_state <= RELOAD1;
			when RELOAD1 =>
				sm_state <= SEND;
		end case;
	end if;
end process;

serial_en <= '1' when ((sm_state = WAIT1) or (sm_state = WAIT2) or (sm_state = WAIT3)) else '0';
output_en <= '1' when sm_state = SEND else '0';

SER1 : entity work.RS232 port map(serial_en,clock,data_in,serial_out,serial_done);
ENC1 : entity work.WS2811_FULL_ENCODER port map(b1,s2);	
OUT1 : entity work.WS2811_OUTPUT port map(s2,data_out,clock,output_en,output_done);
PLL1 : entity work.pll port map (clk_in,clock);
FIFO1 : entity work.FIFO port map (s1,b1,write_buf,buffer_full,buffer_empty,clock);
	
end behv;