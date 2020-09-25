LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Testbench for ALU component
-- Use this TB for your C&A project

ENTITY tb_ALU IS
END tb_ALU;


ARCHITECTURE testbench OF tb_ALU IS
SIGNAL tb_rst_n, tb_clk, tb_go : STD_LOGIC := '0';
SIGNAL tb_ready, tb_error : STD_LOGIC;

signal tb_OperandA : std_logic_vector(3 downto 0) := "0000";
signal tb_OperandB : std_logic_vector(3 downto 0) := "0000";
signal tb_Operation : std_logic_vector(2 downto 0) := "000";
signal tb_result_high, tb_result_low : std_logic_vector(3 downto 0);

COMPONENT ALU_E IS
  PORT(
    reset_n     : in std_logic;
    clk         : in std_logic;
    OperandA    : in std_logic_vector(3 downto 0);
    OperandB    : in std_logic_vector(3 downto 0);
    Operation   : in std_logic_vector(2 downto 0);
    Go          : in std_logic;
    Result_Low	: out std_logic_vector(3 downto 0);
    Result_High	: out std_logic_vector(3 downto 0);
    Completed	: out std_logic;
    ErrorSig	: out std_Logic);
END component;

BEGIN
  ALU1 : ALU_E
    PORT MAP(
      clk => tb_clk,
      reset_n => tb_rst_n,
      OperandA => tb_OperandA,
      OperandB => tb_OperandB,
      Operation => tb_Operation,
      Result_Low => tb_Result_Low,
      Result_High => tb_Result_High,
      Go => tb_go,
      completed => tb_ready,
      errorsig => tb_error);

  tb_clk <= NOT tb_clk AFTER 10 ns;
  
  tb_P:process
  BEGIN
       WAIT FOR 25 ns;
    tb_rst_n <= '1';
    WAIT FOR 40 ns;

    tb_OperandA <= "1011";
    tb_OperandB <= "0010";
    tb_Operation <= "001";              -- test XOR operation
    tb_go <= '1';
    assert tb_error = '0' report "errorsig signal no valid value" severity error;
    assert tb_ready = '0' report "completed signal no valid value" severity error;
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0110" and tb_Result_high = "0000" report "Equivalence operation failed" severity error; -- check result here
    wait until rising_edge(tb_clk);
    assert tb_ready = '1' report "Timing violation: Completed is high for only one clock cycle" severity error;
    wait until falling_edge(tb_ready);
    assert false report "XNOR operation test ended" severity note;


    tb_OperandA <= "1011";
    tb_OperandB <= "0010";
    tb_Operation <= "010";              -- test Shift Left operation
    tb_go <= '1';
    
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "1100" and tb_Result_high = "0010" report "ShiftLeft operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    tb_OperandA <= "1101";
    tb_OperandB <= "0100";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0000" and tb_Result_high = "1101" report "ShiftLeft operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);    
    assert false report "Shift Left operation test ended" severity note;

            -- test Rot Left operation
    tb_OperandA <= "1101";
    tb_OperandB <= "1100";
    tb_go <= '1';

    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0000" and tb_Result_high = "1101" report "RotateLeft operation failed" severity error; -- check result here
    wait until rising_edge(tb_clk);
    assert tb_ready = '1' report "Timing violation: Ready is high for only one clock cycle" severity error;
    wait until falling_edge(tb_ready);
    tb_OperandA <= "1101";
    tb_OperandB <= "1101";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0001" and tb_Result_high = "1010" report "RotateLeft operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    assert false report "Rotate Left operation test ended" severity note;

    tb_Operation <= "011"; 
    tb_OperandA <= "1011";
    tb_OperandB <= "0100";          -- test Shift right operation
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0000" and tb_Result_high = "0000" report "ShiftRight operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    tb_OperandA <= "1011";
    tb_OperandB <= "0010";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0010" and tb_Result_high = "0000" report "ShiftRight operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    assert false report "Shift Right operation test ended" severity note;
   

    tb_OperandA <= "1101";
    tb_OperandB <= "1101";
                 -- test Rot right operation
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "1000" and tb_Result_high = "0110" report "RotateRight operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    tb_OperandA <= "1011";
    tb_OperandB <= "1010";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0010" and tb_Result_high = "1100" report "RotateRight operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    assert false report "Rotate Right operation test ended" severity note;

   
    

-----------------------------------------------------------------------------------------------------------------
    tb_OperandB <= "0010";
    tb_Operation <= "100";              -- test ADD operation
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "1101" and tb_Result_high = "0000" report "ADD operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);

    
    
    tb_OperandA <= "1111";
    tb_OperandB <= "0001";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0000" and tb_Result_high = "0001" report "ADD operation with carry generation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);

    tb_OperandA <= "0011";
    tb_OperandB <= "0101";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "1000" and tb_Result_high = "0000" report "ADD operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    assert false report "ADD operation test ended" severity note;

-------------------------------------------------------------------------------------------------------------------
    tb_Operation <= "101";              -- test SUB operation
    tb_OperandA <= "1111";
    tb_OperandB <= "0001";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
     assert tb_Result_Low = "1110" and tb_Result_high = "0000" report "SUB operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);

    tb_OperandA <= "1010";
    tb_OperandB <= "0111";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0011" and tb_Result_high = "0000" report "SUB operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);

    tb_OperandA <= "1100";
    tb_OperandB <= "1110";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_error = '1' report "SUB error signal generation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
   
    tb_OperandA <= "1011";
    tb_OperandB <= "1001";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0010" and tb_Result_high = "0000" report "SUB operation failed" severity error; -- check result here
    assert tb_error = '0' report "Error signal not resetted" severity error; -- check result here
    wait until falling_edge(tb_ready);
   
    assert false report "SUB operation test ended" severity note;
 
-------------------------------------------------------------------------------------------------------------------  
    tb_Operation <= "110";              -- test MUL operation
    tb_OperandA <= "1111";
    tb_OperandB <= "1111";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0001" and tb_Result_high = "1110" report "MUL operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);

    tb_OperandA <= "1011";
    tb_OperandB <= "1001";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0011" and tb_Result_high = "0110" report "MUL operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
 
    tb_OperandA <= "0011";
    tb_OperandB <= "0101";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "1111" and tb_Result_high = "0000" report "MUL operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
    
    assert false report "MUL operation test ended" severity note;
   
------------------------------------------------------------------------------------------------------------------
    tb_Operation <= "111";              -- test DIV operation
    tb_OperandA <= "1111";
    tb_OperandB <= "1111";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0000" and tb_Result_high = "0001" report "DIV operation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);

    tb_OperandB <= "0000";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_error = '1' report "DIV error signal generation failed" severity error; -- check result here
    wait until falling_edge(tb_ready);
   
    tb_OperandA <= "1101";
    tb_OperandB <= "0011";
    tb_go <= '1';
    wait until rising_edge(tb_clk);
    wait until falling_edge(tb_clk);
    tb_go <= '0';
    wait until rising_edge(tb_clk) and tb_ready = '1';
    assert tb_Result_Low = "0001" and tb_Result_high = "0100" report "DIV operation failed" severity error; -- check result here
    assert tb_error = '0' report "Error signal not resetted" severity error; -- check result here
    wait until falling_edge(tb_ready);
    assert false report "DIV operation test ended 13" severity note;
    assert false report "All checks ended" severity note;
    wait;
  END PROCESS;
  
END testbench;

