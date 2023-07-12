---------------------------------------------
-- Ime i prezime: Petar Mutic
-- Broj indeksa: PR20/2021
---------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;

entity Signal_light is port ( 
	iCLK  	: in  std_logic;
	iRST  	: in  std_logic;
	iLEFT  	: in  std_logic;
	iRIGHT  	: in  std_logic;
	oLEFT		: out std_logic_vector(2 downto 0);
	oRIGHT	: out std_logic_vector(2 downto 0)
	);
end entity;

architecture Behavioral of Signal_light is
	signal sRST_L: std_logic;
	signal sRST_R: std_logic;
	signal sL_EN: std_logic;
	signal sR_EN: std_logic;
	signal sL_TC: std_logic;
	signal sR_TC: std_logic;
	signal sCNTL: std_logic_vector(3 downto 0);
	signal sCNTR: std_logic_vector(3 downto 0);
	
	type STATE is (IDLE,L1,L2,L3,R1,R2,R3);
	signal sSTATE,sNEXT: STATE;
begin
	
	--funkcija izlaza A
	oLEFT<="001" when sSTATE=L1 else
			 "011" when sSTATE=L2 else
			 "111" when sSTATE=L3 else
			 "000";
			 
		
	oRiGHT<="100" when sSTATE=R1 else
			  "110" when sSTATE=R2 else
			  "111" when sSTATE=R3 else
			  "000";
		
	sL_EN<='1' when sSTATE=L1 or sSTATE=L2 or sSTATE=L3 else
			 '0';
		
	sR_EN<='1' when sSTATE=R1 or sSTATE=R2 or sSTATE=R3 else
			 '0';
			 
			
	sRST_L<='1' when sSTATE=R1 or sSTATE=R2 or sSTATE=R3 or sSTATE=IDLE else
			  '0';
			  
	sRST_R<='1' when sSTATE=L1 or sSTATE=L2 or sSTATE=L3 or sSTATE=IDLE else
			  '0';
			  
	--Registar stanja A
	process(iCLK,iRST) begin
		if(iRST='1') then
			sSTATE<=IDLE;
		elsif(rising_edge(iCLK)) then
			sSTATE<=sNEXT;
		end if;
	end process;
	
	--LEFT CNT
	process(iCLK,sRST_L) begin
		if(sRST_L='1') then
			sCNTL<="1001";
		elsif(rising_edge(iCLK)) then
			if(sL_EN='1')then
				if(sCNTL="0000")then
					sCNTL<="1001";
				else
					sCNTL<=sCNTL-1;
				end if;
			end if;
		end if;
	end process;
	
	sL_TC<='1' when sCNTL="0000" else
			 '0';
			 
	
	--RIGHT CNT
	process(iCLK,sRST_R) begin
		if(sRST_R='1') then
			sCNTR<="1001";
		elsif(rising_edge(iCLK)) then
			if(sR_EN='1')then
				if(sCNTR="0000")then
					sCNTR<="1001";
				else
					sCNTR<=sCNTR-1;
				end if;
			end if;
		end if;
	end process;
	
	sR_TC<='1' when sCNTR="0000" else
			 '0';
	
	--Funkcija prelaza stanja A
	process(sSTATE,iLEFT,iRIGHT,sL_TC,sR_TC)begin
		case(sSTATE) is
			when IDLE=>
				if(iLEFT='1')then
					sNEXT<=L1;
				else
					sNEXT<=R1;
				end if;
			when L1=>
				if(iLEFT='1')then
					if(sL_TC='1')then
						sNEXT<=L2;
					else
						sNEXT<=sSTATE;
					end if;
				else 
					sNEXT<=IDLE;
				end if;
			when L2=>
				if(iLEFT='1')then
					if(sL_TC='1')then
						sNEXT<=L3;
					else
						sNEXT<=sSTATE;
					end if;
				else 
					sNEXT<=IDLE;
				end if;
			when L3=>
				if(iLEFT='1')then
					if(sL_TC='1')then
						sNEXT<=IDLE;
					else
						sNEXT<=sSTATE;
					end if;
				else 
					sNEXT<=IDLE;
				end if;
			when R1=>
				if(iRIGHT='1')then
					if(sR_TC='1')then
						sNEXT<=R2;
					else
						sNEXT<=sSTATE;
					end if;
				else 
					sNEXT<=IDLE;
				end if;
			when R2=>
				if(iRIGHT='1')then
					if(sR_TC='1')then
						sNEXT<=R3;
					else
						sNEXT<=sSTATE;
					end if;
				else 
					sNEXT<=IDLE;
				end if;
			when R3=>
				if(iRIGHT='1')then
					if(sR_TC='1')then
						sNEXT<=IDLE;
					else
						sNEXT<=sSTATE;
					end if;
				else 
					sNEXT<=IDLE;
				end if;
			when others=>
				sSTATE<=IDLE;
		end case;
	
	end process;
			 

end Behavioral;
