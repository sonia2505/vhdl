LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Mealy_testbench_Wardner IS
END Mealy_testbench_Wardner;
 
ARCHITECTURE behavior OF Mealy_testbench_Wardner IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MealyElevatorController_Shell
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         stop : IN  std_logic;
         up_down : IN  std_logic;
         floor : OUT  std_logic_vector(3 downto 0);
         nextfloor : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal stop : std_logic := '0';
   signal up_down : std_logic := '0';
	
	SIGNAL floorNum : std_logic_vector(3 downto 0) := "0001";

 	--Outputs
   signal floor : std_logic_vector(3 downto 0);
   signal nextfloor : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MealyElevatorController_Shell PORT MAP (
          clk => clk,
          reset => reset,
          stop => stop,
          up_down => up_down,
          floor => floor,
          nextfloor => nextfloor
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period;
		clk <= '1';
		wait for clk_period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		reset<='1';
			wait for clk_period*2;
			reset<='0';
			
			for i in 1 to 4 loop
				wait for clk_period*2;				
				assert(floor = floorNum ) report "FAIL! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
				assert(floor = floorNum-1 ) report "SUCCESS! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
				stop <= '0';
				up_down <= '1';
				wait for clk_period;
				if (floorNum < "0100") then
				assert(nextfloor = floorNum+1) report "FAIL! Next Floor is"&integer'image(to_integer(unsigned((nextfloor)))) severity note;
				end if;
				assert(nextfloor = floorNum) report "SUCCESS! Next Floor is"&integer'image(to_integer(unsigned((nextfloor)))) severity note;
				wait for clk_period;
				
				stop <= '1';
				floorNum <= floorNum + "0001";
			end loop;			
			
			stop <= '0';
			up_down <= '0';
			wait for clk_period*6;			
			assert(floor = "0000") report "SUCCESS! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
			


      wait;
   end process;

END;