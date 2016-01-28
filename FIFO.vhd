library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mytypes.all;

-------------------------------------------------

entity FIFO is
port(	data_in:		in  	led_data;
		data_out:	out	led_data;
		enable:		in		std_logic;
		full:			out	std_logic;
		idle:			out	std_logic;
		clk: 			in 	std_logic
);
end FIFO;

-------------------------------------------------

architecture behv of FIFO is

type STATES is (M_IDLE,RECV,RECVD,M_FULL,SEND);
signal sm_state : STATES := M_IDLE;
signal address, max : std_logic_vector(7 downto 0) := (others => '0');
signal mem_write :std_logic := '0';
signal ALL_ZERO : std_logic_vector(7 downto 0) := (others => '0');
begin

MEM1 : entity work.MEM port map (data_in,	data_out, address, mem_write, clk);


process (clk)

begin
	if clk'event and clk = '1' then
		case sm_state is
			when M_IDLE =>
				if enable = '1' then
					if not (data_in(23 downto 16) = ALL_ZERO) then
						max <= data_in(23 downto 16);
						sm_state <= RECV;
					end if;
				end if;
			when RECV =>
				if enable = '1' then
					mem_write <= '1';
					sm_state <= RECVD;
				end if;
			when RECVD =>
				mem_write <= '0';
				if address = max then
					sm_state <= M_FULL;
					address <= (others => '0');
				else
					address <= std_logic_vector(unsigned(address)+1);
					sm_state <= RECV;
				end if;
			when M_FULL =>
				if enable = '1' then
					address <= std_logic_vector(unsigned(address)+1);
					sm_state <= SEND;
				end if;
			when SEND =>
				if address = max then
					sm_state <= M_IDLE;
				else
					if enable = '1' then
						address <= std_logic_vector(unsigned(address)+1);
					end if;
				end if;
			when others =>
				sm_state <= M_IDLE;
		end case;
	end if;
end process;

idle <= '1' when sm_state = M_IDLE else '0';
full <= '1' when sm_state = M_FULL else '0';

end behv;