library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- this is the top module of the CPU where all the modules
-- get connected to be fully functional
entity riscv_processor is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC
  );

end riscv_processor;

architecture Behavioral of riscv_process is
begin
  -- define our components here
  component program_counter is
    port (
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
      pc_write : in STD_LOGIC;
      pc_src : in STD_LOGIC_VECTOR(31 downto 0);
      branch_taken : in STD_LOGIC;
      pc : out STD_LOGIC_VECTOR(31 downto 0)
    );
    end component;

    component register_file is
      port (
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          read_addr1: in STD_LOGIC_VECTOR(4 downto 0):
          read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);

          write_addr : in STD_LOGIC_VECTOR(4 downto 0);
          write_data : in STD_LOGIC_VECTOR(31 downto 0);
          reg_write : in STD_LOGIC;

          read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
          read_data2 : out STD_LOGIC_VECTOR(31 downto 0)
      );
    end component;

    component instruction_fetch is
      port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pc : in STD_LOGIC_VECTOR(31 downto 0);
        instruction: out STD_LOGIC_VECTOR(31 downto 0)
      );
    end component;

    component control_unit is
      port (
        opcode : in STD_LOGIC_VECTOR(6 downto 0); 
        funct3 : in STD_LOGIC_VECTOR(2 downto 0);  
        funct7 : in STD_LOGIC_VECTOR(6 downto 0);  

        RegWrite     : out STD_LOGIC;            
        MemRead      : out STD_LOGIC;             
        MemWrite     : out STD_LOGIC;               
        BranchEq     : out STD_LOGIC;              
        memToReg     : out STD_LOGIC;             
        ALUSrc       : out STD_LOGIC;              
        ALUCont      : out STD_LOGIC_VECTOR(2 downto 0); 
        jmp          : out STD_LOGIC              
      );
    end component;

    component alu is
      port (
        op1 : in STD_LOGIC_VECTOR(31 downto 0);  
        op2 : in STD_LOGIC_VECTOR(31 downto 0);  
        opcode : in STD_LOGIC_VECTOR(2 downto 0); 
        res : out STD_LOGIC_VECTOR(31 downto 0); 
        zero_flag : out STD_LOGIC                   
      );
    end component;
  
end Behavioral;
