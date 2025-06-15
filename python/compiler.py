from pycparser import c_parser, c_ast

class CToMIPSGenerator(c_ast.NodeVisitor):
    def __init__(self):
        self.instructions = []
        self.var_map = {}
        self.reg_counter = 0
        self.reg_names = ['$t0', '$t1', '$t2', '$t3', '$t4', '$t5', '$t6']
        self.last_reg = None

    def get_new_reg(self):
        if self.reg_counter >= len(self.reg_names):
            raise Exception("Out of temporary registers!")
        reg = self.reg_names[self.reg_counter]
        self.reg_counter += 1
        return reg

    def visit_FuncDef(self, node):
        self.instructions.append(f"{node.decl.name}:")
        self.visit(node.body)
        self.instructions.append("jr $ra")

    def visit_Compound(self, node):
        for stmt in node.block_items:
            self.visit(stmt)

    def visit_Decl(self, node):
        if isinstance(node.init, c_ast.Constant):
            reg = self.get_new_reg()
            self.var_map[node.name] = reg
            self.instructions.append(f"li {reg}, {node.init.value}")
        elif isinstance(node.init, c_ast.BinaryOp):
            self.visit(node.init)
            self.var_map[node.name] = self.last_reg

    def visit_BinaryOp(self, node):
        if isinstance(node.left, c_ast.ID):
            left = self.var_map[node.left.name]
        else:
            self.visit(node.left)
            left = self.last_reg

        if isinstance(node.right, c_ast.ID):
            right = self.var_map[node.right.name]
        else:
            self.visit(node.right)
            right = self.last_reg

        dest = self.get_new_reg()
        self.last_reg = dest

        if node.op == '+':
            self.instructions.append(f"add {dest}, {left}, {right}")
        elif node.op == '-':
            self.instructions.append(f"sub {dest}, {left}, {right}")
        elif node.op == '*':
            self.instructions.append(f"mul {dest}, {left}, {right}")
        elif node.op == '/':
            self.instructions.append(f"div {left}, {right}")
            self.instructions.append(f"mflo {dest}")
        else:
            raise NotImplementedError(f"Unsupported operation: {node.op}")

    def visit_Return(self, node):
        if isinstance(node.expr, c_ast.ID):
            reg = self.var_map[node.expr.name]
        else:
            self.visit(node.expr)
            reg = self.last_reg
        self.instructions.append(f"move $a0, {reg}")

def c_to_mips(c_code):
    parser = c_parser.CParser()
    ast = parser.parse(c_code)
    generator = CToMIPSGenerator()
    generator.visit(ast)
    return '\n'.join(generator.instructions)

# Sample C code to test
c_code = """
int main() {
    int a = 3;
    int b = 5;
    int c = a + b;
    return c;
}
"""

print(c_to_mips(c_code))
