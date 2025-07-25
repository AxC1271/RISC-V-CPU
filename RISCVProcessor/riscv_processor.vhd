library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- this is the top module of the CPU where all the modules
-- get connected to be fully functional
entity riscv_processor is
  port (
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;

    seg : out STD_LOGIC_VECTOR(6 downto 0);
    ade : out STD_LOGIC_VECTOR(3 downto 0);
    led : out STD_LOGIC_VECTOR(15 downto 0)
  );

end riscv_processor;

architecture Behavioral of riscv_processor is
  -- internal signals
  signal pc : STD_LOGIC_VECTOR(31 downto 0);
  signal instruction : STD_LOGIC_VECTOR(31 downto 0);
  signal opcode, funct3, funct7 : STD_LOGIC_VECTOR(6 downto 0);
  signal RegWrite, MemRead, MemWrite, BranchEq, memToReg, ALUSrc, jmp : STD_LOGIC;
  signal ALUCont : STD_LOGIC_VECTOR(2 downto 0);
  signal read_data1, read_data2, write_data : STD_LOGIC_VECTOR(31 downto 0);
  signal alu_result : STD_LOGIC_VECTOR(31 downto 0);
  signal zero_flag : STD_LOGIC;
  signal op2 : STD_LOGIC_VECTOR(31 downto 0);
  signal branch_taken : STD_LOGIC;

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
        read_addr1: in STD_LOGIC_VECTOR(4 downto 0);
        read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);

        write_addr : in STD_LOGIC_VECTOR(4 downto 0);
        write_data : in STD_LOGIC_VECTOR(31 downto 0);
        reg_write : in STD_LOGIC;

        read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
        read_data2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  component instruction_memory is
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

begin
  PC_inst: program_counter
    port map (
      clk => clk,
      rst => rst,
      pc_write => '1',  
      pc_src => (others => '0'),  -- default PC source
      branch_taken => branch_taken,
      pc => pc
    );

  IM_inst: instruction_memory
    port map (
      clk => clk,
      rst => rst,
      pc => pc,
      instruction => instruction
    );

  opcode <= instruction(6 downto 0);
  funct3 <= instruction(14 downto 12);
  funct7 <= instruction(31 downto 25);

  CU_inst: control_unit
    port map (
      opcode => opcode,
        funct3 => funct3,
        funct7 => funct7,
        RegWrite => RegWrite,
        MemRead => MemRead,
        MemWrite => MemWrite,
        BranchEq => BranchEq,
        memToReg => memToReg,
        ALUSrc => ALUSrc,
        ALUCont => ALUCont,
        jmp => jmp
    );

  RF_inst: register_file
    port map (
        clk => clk,
        rst => rst,
        read_addr1 => instruction(19 downto 15),
        read_addr2 => instruction(24 downto 20),
        write_addr => instruction(11 downto 7),
        write_data => write_data,
        reg_write => RegWrite,
        read_data1 => read_data1,
        read_data2 => read_data2
    );

  op2 <= read_data2 when ALUSrc = '0' else instruction(31 downto 20); -- immediate value

    ALU_inst: alu
      port map (
        op1 => read_data1,
        op2 => op2,
        opcode => ALUCont,
        res => alu_result,
        zero_flag => zero_flag
    );

  write_data <= alu_result when memToReg = '0' else read_data2; 

  branch_taken <= BranchEq and zero_flag;
end Behavioral;
