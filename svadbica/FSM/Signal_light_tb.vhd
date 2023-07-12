---------------------------------------------
-- Ime i prezime: Petar Mutic
-- Broj indeksa: PR20/2021
---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Signal_light_tb is
end entity;
 
architecture Test of Signal_light_tb is
  
   signal sCLK		: std_logic := '0';
   signal sRST 	: std_logic := '0';
   signal siLEFT  : std_logic := '0';
	signal siRIGHT : std_logic := '0';
	signal soLEFT	: std_logic_vector(2 downto 0);
	signal soRIGHT	: std_logic_vector(2 downto 0);
	
	constant iCLK_period : time := 10 ns; 
   
	component Signal_light is port ( 
	iCLK  	: in  std_logic;
	iRST  	: in  std_logic;
	iLEFT  	: in  std_logic;
	iRIGHT  	: in  std_logic;
	oLEFT		: out std_logic_vector(2 downto 0);
	oRIGHT	: out std_logic_vector(2 downto 0)
	);
	end component;

begin

   uut: Signal_light port map (
          iCLK 	=> sCLK,
          iRST 	=> sRST,
			 iLEFT	=> siLEFT,
			 iRIGHT	=> siRIGHT,
          oLEFT 	=> soLEFT,
          oRIGHT 	=> soRIGHT
        );
		  
	iCLK_process: process
	begin
		sCLK <= '0';
		wait for iCLK_period / 2; -- iCLK_period je konstanta
		sCLK <= '1';
		wait for iCLK_period / 2;
	end process;

   stim_proc : process
   begin		
		
		--1)
		siLEFT<='0';
		siRIGHT<='0';
		sRST<='1';
		wait for 5.25*iCLK_period;
		sRST<='0';
		siLEFT<='1';
		wait for 35*iCLK_period;
		siLEFT<='0';
		wait for iCLK_period;
		siRIGHT<='1';
		wait for 35*iCLK_period;
		siRIGHT<='0';
		wait for iCLK_period;
		
		--2)
		siLEFT<='0';
		siRIGHT<='0';
		sRST<='1';
		wait for 3*iCLK_period;
		sRST<='0';
		siRIGHT<='1';
		wait for 13*iCLK_period;
		siRIGHT<='0';
		wait for iCLK_period;
		siLEFT<='1';
		wait for 23*iCLK_period;
		siLEFT<='0';
		wait for iCLK_period;
		
		--3)
		sRST<='1';
		wait;
   end process;
end architecture;
