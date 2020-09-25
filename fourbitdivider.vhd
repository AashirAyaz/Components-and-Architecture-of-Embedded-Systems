----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:00:58 05/29/2017 
-- Design Name: 
-- Module Name:    fourbitdivider - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fourbitdivider is
port(a:in std_logic_vector(3 downto 0);
     b:in std_logic_vector(3 downto 0);
	  start:in std_logic ;
	  clk : in std_logic;
	  completed : out std_logic;
	  quotient:out std_logic_vector(3 downto 0);
	  r:out std_logic_vector (3 downto 0));
	  

end fourbitdivider;

architecture Behavioral of fourbitdivider is

constant initial: std_logic_vector (2 downto 0):="001";
constant calculate: std_logic_vector(2 downto 0) :="010";
constant done: std_logic_vector(2 downto 0):="100";
constant disabled: std_logic_vector (2 downto 0):="111";
signal current_state :std_logic_vector(2 downto 0):="001";
signal x,old_a,old_b:  std_logic_vector(3 downto 0):="0000";
signal y:  std_logic_vector(3 downto 0):="0000";

signal start_delay: std_logic:='0';


begin
process (clk)
variable borrow: std_logic :='0';
variable q:std_logic_vector (3 downto 0):="0000";

  begin
  
 if rising_edge(clk) then

 completed <= '0';
   
    
   case current_state is 
    when initial =>
       x<=a;
       y<=b;
		 r<=(others=>'0');
		quotient<=(others=>'0');
		 start_delay<=start;
       if (start_delay='1' and y="0000") then 
       current_state<=disabled;
        elsif (start_delay ='1')and (a/=old_a or b/=old_b) then
		  old_a<=a;old_b<=b;
		  q:="0000"; 
		  --r<="0000"; 
		  
		  current_state <= calculate;
		  completed<='0';
		  else
		  	current_state<=initial;
		  end if;
		  
    when calculate =>
	 
	 
	     if x >= y then
		  
		  

		  
		  borrow:='0';
		  
		  for k in 0 to 3 loop 
        		x(k)<=borrow xor x(k) xor y(k);
       	   		borrow:=((not x(k))and y(k))or((not x(k))and  borrow)or(y(k) and  borrow);
        	  end loop;
		  
		  
		  q:=q+ 1;
		  
	      
                  
		  end if;
		  
		  if x>=y then
		  current_state<=calculate;
		  completed<='0';
		  else
		  current_state<= done;
		   end if;
			
	 when done =>
                 
                
                r<=x;
		quotient<=q;
		completed<='1';

       current_state<=initial;
when disabled =>
       q:="1111";
       x<="1111";
current_state<=done; 
     
    when others =>
      current_state<=initial;

    end case;
end if ;


end process;
 
		  


		  
		  
        		  



end Behavioral;

