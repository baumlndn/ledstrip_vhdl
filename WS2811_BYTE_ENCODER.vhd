library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity WS2811_BYTE_ENCODER is
port(	data_in:		in  	std_logic_vector(7 downto 0);
		data_out:	out 	std_logic_vector(79 downto 0)
);
end WS2811_BYTE_ENCODER;

-------------------------------------------------

architecture behv of WS2811_BYTE_ENCODER is
begin
	
BIT7 : entity work.WS2811_BIT_ENCODER port map(data_in(7),data_out(79 downto 70));
BIT6 : entity work.WS2811_BIT_ENCODER port map(data_in(6),data_out(69 downto 60));
BIT5 : entity work.WS2811_BIT_ENCODER port map(data_in(5),data_out(59 downto 50));
BIT4 : entity work.WS2811_BIT_ENCODER port map(data_in(4),data_out(49 downto 40));
BIT3 : entity work.WS2811_BIT_ENCODER port map(data_in(3),data_out(39 downto 30));
BIT2 : entity work.WS2811_BIT_ENCODER port map(data_in(2),data_out(29 downto 20));
BIT1 : entity work.WS2811_BIT_ENCODER port map(data_in(1),data_out(19 downto 10));
BIT0 : entity work.WS2811_BIT_ENCODER port map(data_in(0),data_out(9 downto 0));

end behv;