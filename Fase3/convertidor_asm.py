import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import re
from pathlib import Path

# ============================================================
# Tablas de conversión MIPS
# ============================================================

opcode_r = "000000"

funct_table = {
    "add":  "100000",
    "sub":  "100010",
    "and":  "100100",
    "or":   "100101",
    "slt":  "101010",
}

i_table = {
    "lw":   "100011",
    "sw":   "101011",
    "addi": "001000",
    "beq":  "000100",
    "bne":  "000101",
}

j_table = {
    "j":    "000010",
}

# Registros MIPS
reg_names = {f"${i}": f"{i:05b}" for i in range(32)}
reg_named_list = ["$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                  "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                  "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                  "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"]
for i, name in enumerate(reg_named_list):
    reg_names[name] = f"{i:05b}"

bin_to_reg = {v: k for k, v in reg_names.items()}

# ============================================================
# Conversión: BINARIO (4 líneas de 8 bits) -> ASM
# ============================================================

def bin_to_asm_content(bin_content):
    """
    Convierte contenido binario donde CADA LÍNEA es 1 byte (8 bits)
    Se agrupan 4 líneas para formar una instrucción de 32 bits
    """
    # Leer todas las líneas no vacías
    lines = [line.strip() for line in bin_content.split('\n') if line.strip()]
    
    # Verificar que sea múltiplo de 4
    if len(lines) % 4 != 0:
        return None, f"❌ Error: {len(lines)} líneas no es múltiplo de 4 (cada instrucción necesita 4 líneas de 8 bits)"
    
    instructions = []
    errors = []
    
    # Procesar cada grupo de 4 líneas (1 instrucción)
    for i in range(0, len(lines), 4):
        # UNIR las 4 líneas en una sola cadena de 32 bits
        byte0 = lines[i]      # bits 31-24
        byte1 = lines[i+1]    # bits 23-16
        byte2 = lines[i+2]    # bits 15-8
        byte3 = lines[i+3]    # bits 7-0
        
        bin_instr = byte0 + byte1 + byte2 + byte3
        
        # Validar longitud
        if len(bin_instr) != 32:
            errors.append(f"Instrucción {i//4 + 1}: {len(bin_instr)} bits (deben ser 32) - revisar líneas {i+1}-{i+4}")
            continue
        
        # Verificar que solo contenga 0s y 1s
        if not all(c in '01' for c in bin_instr):
            errors.append(f"Instrucción {i//4 + 1}: contiene caracteres no binarios")
            continue
        
        # Extraer opcode (primeros 6 bits)
        opcode = bin_instr[0:6]
        
        try:
            # ----- TIPO R (opcode = 000000) -----
            if opcode == opcode_r:
                rs = bin_instr[6:11]
                rt = bin_instr[11:16]
                rd = bin_instr[16:21]
                shamt = bin_instr[21:26]
                funct = bin_instr[26:32]
                
                if funct in funct_table.values():
                    instr_name = [k for k, v in funct_table.items() if v == funct][0]
                    asm = f"{instr_name} {bin_to_reg.get(rd, '?')}, {bin_to_reg.get(rs, '?')}, {bin_to_reg.get(rt, '?')}"
                    instructions.append(asm)
                else:
                    instructions.append(f".word 0x{int(bin_instr, 2):08X}   # Unknown R-type funct={funct}")
            
            # ----- TIPO I -----
            elif opcode in i_table.values():
                instr_name = [k for k, v in i_table.items() if v == opcode][0]
                rs = bin_to_reg.get(bin_instr[6:11], f"${int(bin_instr[6:11],2)}")
                rt = bin_to_reg.get(bin_instr[11:16], f"${int(bin_instr[11:16],2)}")
                imm = int(bin_instr[16:32], 2)
                if imm >= 32768:
                    imm = imm - 65536  # Convertir a signed
                
                if instr_name in ("lw", "sw"):
                    asm = f"{instr_name} {rt}, {imm}({rs})"
                else:  # addi, beq, bne
                    asm = f"{instr_name} {rt}, {rs}, {imm}"
                instructions.append(asm)
            
            # ----- TIPO J -----
            elif opcode in j_table.values():
                addr = int(bin_instr[6:32], 2)
                asm = f"j 0x{addr:07X}"
                instructions.append(asm)
            
            else:
                instructions.append(f".word 0x{int(bin_instr, 2):08X}   # Unknown opcode {opcode}")
                
        except Exception as e:
            errors.append(f"Instrucción {i//4 + 1}: {str(e)}")
    
    if errors:
        return None, "\n".join(errors)
    
    return "\n".join(instructions), f"✅ Conversión exitosa: {len(instructions)} instrucciones (unidas de {len(lines)} líneas)"

# ============================================================
# Conversión: ASM -> BINARIO (4 líneas de 8 bits por instrucción)
# ============================================================

def asm_to_bin_content(asm_content):
    """Convierte ASM a formato binario (4 líneas de 8 bits por instrucción)"""
    lines = asm_content.split('\n')
    bin_instructions = []
    errors = []
    line_num = 0
    
    for line in lines:
        line_num += 1
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        
        parts = re.split(r'[ ,()]+', line)
        instr = parts[0].lower()
        bin_code = None
        
        try:
            # Tipo R
            if instr in funct_table:
                if len(parts) != 4:
                    raise SyntaxError(f"Formato R incorrecto (necesita 3 registros)")
                rd = reg_names.get(parts[1])
                rs = reg_names.get(parts[2])
                rt = reg_names.get(parts[3])
                if None in (rd, rs, rt):
                    raise NameError(f"Registro inválido")
                shamt = "00000"
                funct = funct_table[instr]
                bin_code = opcode_r + rs + rt + rd + shamt + funct
            
            # Tipo I
            elif instr in i_table:
                if instr in ("lw", "sw"):
                    if len(parts) != 4:
                        raise SyntaxError(f"Formato I incorrecto para {instr}")
                    rt = reg_names.get(parts[1])
                    offset = parts[2]
                    rs = reg_names.get(parts[3])
                    if None in (rt, rs):
                        raise NameError(f"Registro inválido")
                    offset_int = int(offset)
                    if offset_int < -32768 or offset_int > 32767:
                        raise ValueError(f"offset fuera de rango (-32768..32767)")
                    offset_bin = f"{offset_int & 0xFFFF:016b}"
                    bin_code = i_table[instr] + rs + rt + offset_bin
                else:  # addi, beq, bne
                    if len(parts) != 4:
                        raise SyntaxError(f"Formato I incorrecto para {instr}")
                    rt = reg_names.get(parts[1])
                    rs = reg_names.get(parts[2])
                    imm = parts[3]
                    if None in (rt, rs):
                        raise NameError(f"Registro inválido")
                    imm_int = int(imm)
                    if imm_int < -32768 or imm_int > 32767:
                        raise ValueError(f"inmediato fuera de rango (-32768..32767)")
                    imm_bin = f"{imm_int & 0xFFFF:016b}"
                    bin_code = i_table[instr] + rs + rt + imm_bin
            
            # Tipo J
            elif instr in j_table:
                if len(parts) != 2:
                    raise SyntaxError(f"Formato J incorrecto (necesita dirección)")
                address = parts[1]
                addr_int = int(address, 0)
                if addr_int < 0 or addr_int > 0x3FFFFFF:
                    raise ValueError(f"dirección fuera de rango (0..0x3FFFFFF)")
                addr_bin = f"{addr_int:026b}"
                bin_code = j_table[instr] + addr_bin
            
            else:
                raise SyntaxError(f"Instrucción no reconocida '{instr}'")
            
            bin_instructions.append(bin_code)
            
        except Exception as e:
            errors.append(f"Línea {line_num}: {e}")
    
    if errors:
        return None, "\n".join(errors)
    
    # Convertir cada instrucción de 32 bits a 4 líneas de 8 bits
    result_lines = []
    for idx, bin_instr in enumerate(bin_instructions):
        byte0 = bin_instr[0:8]   # bits 31-24
        byte1 = bin_instr[8:16]  # bits 23-16
        byte2 = bin_instr[16:24] # bits 15-8
        byte3 = bin_instr[24:32] # bits 7-0
        result_lines.extend([byte0, byte1, byte2, byte3])
    
    return "\n".join(result_lines), f"✅ Conversión exitosa: {len(bin_instructions)} instrucciones → {len(result_lines)} líneas de 8 bits"

# ============================================================
# Interfaz Gráfica (igual que antes, pero con mejor feedback)
# ============================================================

class MIPSConverterGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("🔄 Convertidor MIPS - ASM ↔ Binario (8 bits/linea)")
        self.root.geometry("1100x700")
        self.root.resizable(True, True)
        
        self.input_path = tk.StringVar()
        self.output_path = tk.StringVar()
        self.input_content = ""
        self.output_content = ""
        
        self.setup_ui()
    
    def setup_ui(self):
        main_frame = tk.Frame(self.root, padx=10, pady=10)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Frame de archivos
        file_frame = tk.LabelFrame(main_frame, text="📁 Archivos", padx=10, pady=5)
        file_frame.pack(fill=tk.X, pady=(0,10))
        
        tk.Label(file_frame, text="Entrada:").grid(row=0, column=0, sticky=tk.W, pady=5)
        tk.Entry(file_frame, textvariable=self.input_path, width=70).grid(row=0, column=1, padx=5)
        tk.Button(file_frame, text="📂 Buscar", command=self.select_input).grid(row=0, column=2)
        
        tk.Label(file_frame, text="Salida:").grid(row=1, column=0, sticky=tk.W, pady=5)
        tk.Entry(file_frame, textvariable=self.output_path, width=70).grid(row=1, column=1, padx=5)
        tk.Button(file_frame, text="💾 Guardar como...", command=self.select_output).grid(row=1, column=2)
        
        # Botones
        action_frame = tk.Frame(main_frame)
        action_frame.pack(fill=tk.X, pady=10)
        
        tk.Button(action_frame, text="🔄 Cargar archivo", command=self.load_file, 
                  bg="#4CAF50", fg="white", font=("Arial", 10, "bold"), padx=20).pack(side=tk.LEFT, padx=5)
        tk.Button(action_frame, text="✨ Convertir", command=self.convert, 
                  bg="#2196F3", fg="white", font=("Arial", 10, "bold"), padx=20).pack(side=tk.LEFT, padx=5)
        tk.Button(action_frame, text="💾 Guardar salida", command=self.save_output, 
                  bg="#FF9800", fg="white", font=("Arial", 10, "bold"), padx=20).pack(side=tk.LEFT, padx=5)
        
        # Información del formato
        info_frame = tk.Frame(main_frame, bg="#FFFFCC", relief=tk.RIDGE, bd=1)
        info_frame.pack(fill=tk.X, pady=(0,10))
        info_label = tk.Label(info_frame, text="ℹ️ FORMATO BINARIO: Cada instrucción de 32 bits = 4 líneas de 8 bits (1 byte por línea)", 
                              bg="#FFFFCC", font=("Arial", 9))
        info_label.pack(pady=5)
        
        # Paneles de contenido
        content_frame = tk.Frame(main_frame)
        content_frame.pack(fill=tk.BOTH, expand=True)
        
        left_frame = tk.LabelFrame(content_frame, text="📄 Contenido original", padx=5, pady=5)
        left_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0,5))
        self.input_text = scrolledtext.ScrolledText(left_frame, height=28, width=50, wrap=tk.NONE, font=("Courier", 9))
        self.input_text.pack(fill=tk.BOTH, expand=True)
        
        right_frame = tk.LabelFrame(content_frame, text="✨ Resultado convertido", padx=5, pady=5)
        right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=(5,0))
        self.output_text = scrolledtext.ScrolledText(right_frame, height=28, width=50, wrap=tk.NONE, font=("Courier", 9))
        self.output_text.pack(fill=tk.BOTH, expand=True)
        
        self.status_bar = tk.Label(main_frame, text="✅ Listo", bd=1, relief=tk.SUNKEN, anchor=tk.W)
        self.status_bar.pack(fill=tk.X, pady=(10,0))
    
    def select_input(self):
        filename = filedialog.askopenfilename(
            title="Seleccionar archivo de entrada",
            filetypes=[("Archivos soportados", "*.asm *.mem *.txt"), 
                      ("Ensamblador MIPS", "*.asm"),
                      ("Binario MIPS (8 bits/linea)", "*.mem"),
                      ("Texto", "*.txt"),
                      ("Todos los archivos", "*.*")]
        )
        if filename:
            self.input_path.set(filename)
            input_file = Path(filename)
            if input_file.suffix == '.asm':
                output_name = input_file.stem + '.mem'
            else:
                output_name = input_file.stem + '.asm'
            self.output_path.set(str(input_file.parent / output_name))
    
    def select_output(self):
        filename = filedialog.asksaveasfilename(
            title="Guardar archivo de salida",
            filetypes=[("Archivos soportados", "*.asm *.mem *.txt"),
                      ("Ensamblador MIPS", "*.asm"),
                      ("Binario MIPS (8 bits/linea)", "*.mem"),
                      ("Texto", "*.txt")]
        )
        if filename:
            self.output_path.set(filename)
    
    def load_file(self):
        if not self.input_path.get():
            messagebox.showwarning("Advertencia", "Seleccione un archivo de entrada primero")
            return
        
        try:
            with open(self.input_path.get(), 'r', encoding='utf-8') as f:
                self.input_content = f.read()
            
            self.input_text.delete(1.0, tk.END)
            self.input_text.insert(1.0, self.input_content)
            
            # Mostrar información del formato
            lines = [l for l in self.input_content.split('\n') if l.strip()]
            self.status_bar.config(text=f"✅ Archivo cargado: {len(lines)} líneas - {self.input_path.get()}")
            
            self.output_text.delete(1.0, tk.END)
            self.output_content = ""
            
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo cargar el archivo:\n{str(e)}")
            self.status_bar.config(text=f"❌ Error: {str(e)}")
    
    def convert(self):
        if not self.input_content:
            messagebox.showwarning("Advertencia", "Cargue un archivo primero")
            return
        
        input_file = Path(self.input_path.get())
        
        # Detección automática
        if input_file.suffix == '.asm':
            # ASM -> Binario
            result, message = asm_to_bin_content(self.input_content)
            if result:
                self.output_content = result
                self.output_text.delete(1.0, tk.END)
                self.output_text.insert(1.0, result)
                self.status_bar.config(text=f"✅ {message}")
            else:
                messagebox.showerror("Error de conversión", message)
                self.status_bar.config(text=f"❌ {message}")
        else:
            # Binario -> ASM
            result, message = bin_to_asm_content(self.input_content)
            if result:
                self.output_content = result
                self.output_text.delete(1.0, tk.END)
                self.output_text.insert(1.0, result)
                self.status_bar.config(text=f"✅ {message}")
            else:
                messagebox.showerror("Error de conversión", message)
                self.status_bar.config(text=f"❌ {message}")
    
    def save_output(self):
        if not self.output_content:
            messagebox.showwarning("Advertencia", "No hay contenido convertido para guardar")
            return
        
        if not self.output_path.get():
            self.select_output()
        
        if self.output_path.get():
            try:
                with open(self.output_path.get(), 'w', encoding='utf-8') as f:
                    f.write(self.output_content)
                messagebox.showinfo("Éxito", f"Archivo guardado en:\n{self.output_path.get()}")
                self.status_bar.config(text=f"✅ Guardado: {self.output_path.get()}")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo guardar:\n{str(e)}")

# ============================================================
# Main
# ============================================================

if __name__ == "__main__":
    root = tk.Tk()
    app = MIPSConverterGUI(root)
    root.mainloop()
