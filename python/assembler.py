import re

reg_map = {
    'zero':0, 'ra':1, 'sp':2, 'gp':3, 'tp':4,
    't0':5, 't1':6, 't2':7, 't3':28, 't4':29, 't5':30, 't6':31,
    'a0':10
}

opcode_map = {
    'add': 0b0110011,
    'sub': 0b0110011,
    'mul': 0b0110011,
    'div': 0b0110011,
    'addi':0b0010011,
    'jalr':0b1100111
}

funct3_map = {
    'add': 0b000,
    'sub': 0b000,
    'mul': 0b000,
    'div': 0b100,
    'addi':0b000,
    'jalr':0b000
}

funct7_map = {
    'add': 0b0000000,
    'sub': 0b0100000,
    'mul': 0b0000001,
    'div': 0b0000001
}

def reg_num(reg):
    if reg not in reg_map:
        raise ValueError(f"Unknown register {reg}")
    return reg_map[reg]

def to_bin(value, bits):
    if value < 0:
        value = (1 << bits) + value
    return f'{value:0{bits}b}'

def assemble_r_type(inst, rd, rs1, rs2):
    opcode = opcode_map[inst]
    funct3 = funct3_map[inst]
    funct7 = funct7_map[inst]
    rd = reg_num(rd)
    rs1 = reg_num(rs1)
    rs2 = reg_num(rs2)
    binary = (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
    return binary

def assemble_i_type(inst, rd, rs1, imm):
    opcode = opcode_map[inst]
    funct3 = funct3_map[inst]
    rd = reg_num(rd)
    rs1 = reg_num(rs1)
    imm_val = int(imm)
    imm_bin = imm_val & 0xfff  
    binary = (imm_bin << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
    return binary

def parse_line(line):
    line = line.split('#')[0].strip()
    if not line:
        return None
    if line.endswith(':'):
        return ('label', line[:-1])
    if line == 'ret':
        binary = assemble_i_type('jalr', 'zero', 'ra', 0)
        return ('instruction', 'jalr', ['zero', 'ra', '0'], binary)
    pattern = r'(\w+)\s+([^,]+)(?:,\s*([^,]+)(?:,\s*(.+))?)?'
    match = re.match(pattern, line)
    if not match:
        raise ValueError(f"Cannot parse line: {line}")
    inst = match.group(1)
    args = [arg.strip() for arg in match.groups()[1:] if arg]
    return ('instruction', inst, args)

def assemble_instruction(inst, args):
    if inst in ['add', 'sub', 'mul', 'div']:
        if len(args) != 3:
            raise ValueError(f"{inst} needs 3 args")
        rd, rs1, rs2 = args
        return assemble_r_type(inst, rd, rs1, rs2)
    elif inst == 'addi':
        if len(args) != 3:
            raise ValueError(f"{inst} needs 3 args")
        rd, rs1, imm = args
        return assemble_i_type(inst, rd, rs1, imm)
    elif inst == 'jalr':
        if len(args) != 3:
            raise ValueError(f"{inst} needs 3 args")
        rd, rs1, imm = args
        return assemble_i_type(inst, rd, rs1, imm)
    else:
        raise NotImplementedError(f"Instruction {inst} not supported")

def assemble(asm_code):
    machine_codes = []
    for line in asm_code.splitlines():
        parsed = parse_line(line)
        if parsed is None:
            continue
        kind = parsed[0]
        if kind == 'label':
            continue
        elif kind == 'instruction':
            inst, args = parsed[1], parsed[2]
            binary = assemble_instruction(inst, args)
            machine_codes.append(f"{binary:032b}")
    return machine_codes

asm_code = """
main:
addi t0, zero, 3
addi t1, zero, 5
add t2, t0, t1
addi a0, t2, 0
ret
"""

binary_instructions = assemble(asm_code)
for i, b in enumerate(binary_instructions):
    print(f"{i:02}: {b}  0x{int(b, 2):08x}")
