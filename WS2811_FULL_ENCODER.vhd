library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity WS2811_FULL_ENCODER is
port(	data_in:		in  	std_logic_vector(23 downto 0);
		data_out:	out 	std_logic_vector(239 downto 0)
);
end WS2811_FULL_ENCODER;

-------------------------------------------------

architecture behv of WS2811_FULL_ENCODER is
begin
	
BYTE2 : entity work.WS2811_BYTE_ENCODER port map(data_in(23 downto 16),data_out(239 downto 160));	
BYTE1 : entity work.WS2811_BYTE_ENCODER port map(data_in(15 downto 8),data_out(159 downto 80));
BYTE0 : entity work.WS2811_BYTE_ENCODER port map(data_in(7 downto 0),data_out(79 downto 0));
	
end behv;