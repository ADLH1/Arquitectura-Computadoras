import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import os
import re

class MIPSConverter:
    def __init__(self, root):
        self.root = root
        self.root.title("Conversor de Instrucciones MIPS")
        self.root.geometry("800x600")
        
        # Diccionario de instrucciones MIPS
        self.instructions = {
            # Tipo R
            'add': {'type': 'R', 'op': '000000', 'funct': '100000'},
            'sub': {'type': 'R', 'op': '000000', 'funct': '100010'},
            'and': {'type': 'R', 'op': '000000', 'funct': '100100'},
            'or': {'type': 'R', 'op': '000000', 'funct': '100101'},
            'slt': {'type': 'R', 'op': '000000', 'funct': '101010'},
            
            # Tipo I
            'addi': {'type': 'I', 'op': '001000'},
            'lw': {'type': 'I', 'op': '100011'},
            'sw': {'type': 'I', 'op': '101011'},
            'beq': {'type': 'I', 'op': '000100'},
            'bne': {'type': 'I', 'op': '000101'},
            
            # Tipo J
            'j': {'type': 'J', 'op': '000010'},
            'jal': {'type': 'J', 'op': '000011'}
        }
        
        # Diccionario de registros
        self.registers = {
            '$zero': '00000', '$0': '00000',
            '$at': '00001', '$1': '00001',
            '$v0': '00010', '$2': '00010',
            '$v1': '00011', '$3': '00011',
            '$a0': '00100', '$4': '00100',
            '$a1': '00101', '$5': '00101',
            '$a2': '00110', '$6': '00110',
            '$a3': '00111', '$7': '00111',
            '$t0': '01000', '$8': '01000',
            '$t1': '01001', '$9': '01001',
            '$t2': '01010', '$10': '01010',
            '$t3': '01011', '$11': '01011',
            '$t4': '01100', '$12': '01100',
            '$t5': '01101', '$13': '01101',
            '$t6': '01110', '$14': '01110',
            '$t7': '01111', '$15': '01111',
            '$s0': '10000', '$16': '10000',
            '$s1': '10001', '$17': '10001',
            '$s2': '10010', '$18': '10010',
            '$s3': '10011', '$19': '10011',
            '$s4': '10100', '$20': '10100',
            '$s5': '10101', '$21': '10101',
            '$s6': '10110', '$22': '10110',
            '$s7': '10111', '$23': '10111',
            '$t8': '11000', '$24': '11000',
            '$t9': '11001', '$25': '11001',
            '$k0': '11010', '$26': '11010',
            '$k1': '11011', '$27': '11011',
            '$gp': '11100', '$28': '11100',
            '$sp': '11101', '$29': '11101',
            '$fp': '11110', '$30': '11110',
            '$ra': '11111', '$31': '11111'
        }
        
        self.create_widgets()
    
    def create_widgets(self):
        # Frame principal
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Opciones de entrada
        ttk.Label(main_frame, text="Seleccione método de entrada:").grid(row=0, column=0, sticky=tk.W, pady=5)
        
        self.input_method = tk.StringVar(value="file")
        ttk.Radiobutton(main_frame, text="Cargar archivo", variable=self.input_method, 
                       value="file", command=self.toggle_input_method).grid(row=1, column=0, sticky=tk.W)
        ttk.Radiobutton(main_frame, text="Escribir manualmente", variable=self.input_method, 
                       value="manual", command=self.toggle_input_method).grid(row=1, column=1, sticky=tk.W)
        
        # Frame para carga de archivo
        self.file_frame = ttk.Frame(main_frame)
        self.file_frame.grid(row=2, column=0, columnspan=2, sticky=(tk.W, tk.E), pady=10)
        
        ttk.Label(self.file_frame, text="Archivo:").grid(row=0, column=0, sticky=tk.W)
        self.file_path = tk.StringVar()
        ttk.Entry(self.file_frame, textvariable=self.file_path, width=50).grid(row=0, column=1, padx=5)
        ttk.Button(self.file_frame, text="Buscar", command=self.browse_file).grid(row=0, column=2)
        
        # Frame para entrada manual
        self.manual_frame = ttk.Frame(main_frame)
        ttk.Label(self.manual_frame, text="Ingrese instrucciones (una por línea):").grid(row=0, column=0, sticky=tk.W)
        self.manual_text = scrolledtext.ScrolledText(self.manual_frame, width=80, height=15)
        self.manual_text.grid(row=1, column=0, pady=5)
        
        # Opciones de salida
        ttk.Label(main_frame, text="Formato de salida:").grid(row=3, column=0, sticky=tk.W, pady=5)
        self.output_format = tk.StringVar(value="mem")
        output_frame = ttk.Frame(main_frame)
        output_frame.grid(row=4, column=0, columnspan=2, sticky=tk.W)
        ttk.Radiobutton(output_frame, text=".mem (binario)", variable=self.output_format, value="mem").pack(side=tk.LEFT, padx=5)
        ttk.Radiobutton(output_frame, text=".txt (binario)", variable=self.output_format, value="txt").pack(side=tk.LEFT, padx=5)
        ttk.Radiobutton(output_frame, text=".asm (ensamblador)", variable=self.output_format, value="asm").pack(side=tk.LEFT, padx=5)
        
        # Botones de acción
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=5, column=0, columnspan=2, pady=20)
        ttk.Button(button_frame, text="Convertir", command=self.convert).pack(side=tk.LEFT, padx=5)
        ttk.Button(button_frame, text="Limpiar", command=self.clear_all).pack(side=tk.LEFT, padx=5)
        
        # Área de resultados
        ttk.Label(main_frame, text="Resultado:").grid(row=6, column=0, sticky=tk.W, pady=5)
        self.result_text = scrolledtext.ScrolledText(main_frame, width=80, height=10)
        self.result_text.grid(row=7, column=0, columnspan=2, pady=5)
        
        self.toggle_input_method()
    
    def toggle_input_method(self):
        if self.input_method.get() == "file":
            self.file_frame.grid()
            self.manual_frame.grid_remove()
        else:
            self.file_frame.grid_remove()
            self.manual_frame.grid()
    
    def browse_file(self):
        filetypes = [
            ('Archivos soportados', '*.asm *.txt *.mem'),
            ('Archivos ASM', '*.asm'),
            ('Archivos TXT', '*.txt'),
            ('Archivos MEM', '*.mem'),
            ('Todos los archivos', '*.*')
        ]
        filename = filedialog.askopenfilename(filetypes=filetypes)
        if filename:
            self.file_path.set(filename)
    
    def parse_register(self, reg):
        """Convierte un registro a su representación binaria de 5 bits"""
        reg = reg.strip().lower()
        if reg in self.registers:
            return self.registers[reg]
        return None
    
    def parse_immediate(self, imm):
        """Convierte un inmediato a binario de 16 bits (complemento a 2)"""
        try:
            value = int(imm)
            if value < -32768 or value > 32767:
                return None
            # Convertir a binario de 16 bits en complemento a 2
            if value < 0:
                value = (1 << 16) + value
            return format(value, '016b')
        except ValueError:
            return None
    
    def parse_address(self, addr):
        """Convierte una dirección a binario de 26 bits"""
        try:
            # En MIPS real, la dirección es una palabra (4 bytes), así que dividimos entre 4
            value = int(addr)
            if value < 0 or value > 268435455:  # 2^28 - 1
                return None
            return format(value >> 2, '026b')
        except ValueError:
            return None
    
    def parse_instruction_r(self, parts):
        """Parsea instrucción tipo R"""
        if len(parts) != 4:
            return None, "Formato incorrecto. Se espera: instrucción rd, rs, rt"
        
        instr, rd, rs, rt = parts
        
        if instr not in self.instructions or self.instructions[instr]['type'] != 'R':
            return None, f"Instrucción {instr} no es de tipo R o no está soportada"
        
        op = self.instructions[instr]['op']
        funct = self.instructions[instr]['funct']
        
        rs_bin = self.parse_register(rs)
        rt_bin = self.parse_register(rt)
        rd_bin = self.parse_register(rd)
        
        if not all([rs_bin, rt_bin, rd_bin]):
            return None, f"Registro inválido: {rs}, {rt}, {rd}"
        
        shamt = "00000"  # Siempre cero por esta ocasión
        
        binary = op + rs_bin + rt_bin + rd_bin + shamt + funct
        return binary, None
    
    def parse_instruction_i(self, parts):
        """Parsea instrucción tipo I"""
        if len(parts) != 4:
            return None, "Formato incorrecto. Se espera: instrucción rt, rs, inmediato"
        
        instr, rt, rs, imm = parts
        
        if instr not in self.instructions or self.instructions[instr]['type'] != 'I':
            return None, f"Instrucción {instr} no es de tipo I o no está soportada"
        
        op = self.instructions[instr]['op']
        
        rs_bin = self.parse_register(rs)
        rt_bin = self.parse_register(rt)
        
        if not all([rs_bin, rt_bin]):
            return None, f"Registro inválido: {rs}, {rt}"
        
        imm_bin = self.parse_immediate(imm)
        if not imm_bin:
            return None, f"Inmediato inválido: {imm}"
        
        binary = op + rs_bin + rt_bin + imm_bin
        return binary, None
    
    def parse_instruction_j(self, parts):
        """Parsea instrucción tipo J"""
        if len(parts) != 2:
            return None, "Formato incorrecto. Se espera: instrucción dirección"
        
        instr, addr = parts
        
        if instr not in self.instructions or self.instructions[instr]['type'] != 'J':
            return None, f"Instrucción {instr} no es de tipo J o no está soportada"
        
        op = self.instructions[instr]['op']
        
        addr_bin = self.parse_address(addr)
        if not addr_bin:
            return None, f"Dirección inválida: {addr}"
        
        binary = op + addr_bin
        return binary, None
    
    def parse_line(self, line):
        """Parsea una línea de código ensamblador"""
        line = line.strip()
        if not line or line.startswith('#'):
            return None, None
        
        # Eliminar comentarios
        if '#' in line:
            line = line[:line.index('#')].strip()
        
        # Tokenizar
        # Reemplazar comas y paréntesis por espacios
        line = line.replace(',', ' ').replace('(', ' ').replace(')', ' ')
        parts = line.split()
        
        if not parts:
            return None, None
        
        instr = parts[0].lower()
        
        if instr not in self.instructions:
            return None, f"Instrucción no soportada: {instr}"
        
        instr_type = self.instructions[instr]['type']
        
        if instr_type == 'R':
            if len(parts) != 4:
                return None, "Número incorrecto de operandos para instrucción R"
            return self.parse_instruction_r(parts)
        
        elif instr_type == 'I':
            if len(parts) != 4:
                return None, "Número incorrecto de operandos para instrucción I"
            return self.parse_instruction_i(parts)
        
        elif instr_type == 'J':
            if len(parts) != 2:
                return None, "Número incorrecto de operandos para instrucción J"
            return self.parse_instruction_j(parts)
        
        return None, "Error desconocido"
    
    def convert_asm_to_binary(self, asm_code):
        """Convierte código ensamblador a binario"""
        lines = asm_code.strip().split('\n')
        binary_lines = []
        errors = []
        
        for i, line in enumerate(lines, 1):
            binary, error = self.parse_line(line)
            if error:
                errors.append(f"Línea {i}: {error} - '{line}'")
            elif binary:
                binary_lines.append(binary)
        
        if errors:
            return None, errors
        
        return binary_lines, None
    
    def read_input_file(self, filepath):
        """Lee el archivo de entrada según su extensión"""
        ext = os.path.splitext(filepath)[1].lower()
        
        with open(filepath, 'r') as f:
            content = f.read()
        
        if ext == '.asm':
            return self.convert_asm_to_binary(content)
        elif ext in ['.txt', '.mem']:
            # Si es archivo binario, solo validamos que sean líneas de 32 bits
            lines = content.strip().split('\n')
            valid_lines = []
            errors = []
            for i, line in enumerate(lines, 1):
                line = line.strip()
                if line and re.match(r'^[01]{32}$', line):
                    valid_lines.append(line)
                elif line:
                    errors.append(f"Línea {i}: '{line}' no es binario válido de 32 bits")
            
            if errors:
                return None, errors
            return valid_lines, None
        else:
            return None, [f"Extensión de archivo no soportada: {ext}"]
    
    def save_output(self, data, original_filename=None):
        """Guarda el resultado en el formato seleccionado"""
        if not data:
            return False
        
        # Determinar extensión
        ext_map = {'mem': '.mem', 'txt': '.txt', 'asm': '.asm'}
        ext = ext_map[self.output_format.get()]
        
        # Generar nombre de archivo
        if original_filename:
            base = os.path.splitext(original_filename)[0]
            filename = f"{base}_output{ext}"
        else:
            filename = f"output{ext}"
        
        # Guardar archivo
        filepath = filedialog.asksaveasfilename(
            defaultextension=ext,
            filetypes=[(f'Archivos {ext}', f'*{ext}'), ('Todos los archivos', '*.*')],
            initialfile=filename
        )
        
        if not filepath:
            return False
        
        if self.output_format.get() == 'asm':
            # Convertir de binario a ensamblador (simplificado)
            output_data = "\n".join([self.binary_to_asm(b) for b in data])
        else:
            output_data = "\n".join(data)
        
        with open(filepath, 'w') as f:
            f.write(output_data)
        
        messagebox.showinfo("Éxito", f"Archivo guardado como: {filepath}")
        return True
    
    def binary_to_asm(self, binary):
        """Convierte binario de 32 bits a ensamblador (versión simplificada)"""
        if len(binary) != 32:
            return "Instrucción inválida"
        
        op = binary[:6]
        
        # Buscar instrucción por opcode
        for instr_name, instr_info in self.instructions.items():
            if instr_info['op'] == op:
                if instr_info['type'] == 'R' and 'funct' in instr_info:
                    funct = binary[26:]
                    if instr_info['funct'] == funct:
                        rs = int(binary[6:11], 2)
                        rt = int(binary[11:16], 2)
                        rd = int(binary[16:21], 2)
                        return f"{instr_name} ${rd}, ${rs}, ${rt}"
                elif instr_info['type'] == 'I':
                    rs = int(binary[6:11], 2)
                    rt = int(binary[11:16], 2)
                    imm = int(binary[16:], 2)
                    if imm >= 32768:
                        imm -= 65536
                    return f"{instr_name} ${rt}, ${rs}, {imm}"
                elif instr_info['type'] == 'J':
                    addr = int(binary[6:], 2) << 2
                    return f"{instr_name} {addr}"
        
        return f"Instrucción desconocida: {binary}"
    
    def convert(self):
        """Función principal de conversión"""
        self.result_text.delete(1.0, tk.END)
        
        # Obtener entrada
        if self.input_method.get() == "file":
            filepath = self.file_path.get()
            if not filepath or not os.path.exists(filepath):
                messagebox.showerror("Error", "Por favor seleccione un archivo válido")
                return
            
            result, errors = self.read_input_file(filepath)
            original_filename = filepath
        else:
            asm_code = self.manual_text.get(1.0, tk.END)
            if not asm_code.strip():
                messagebox.showerror("Error", "Por favor ingrese instrucciones")
                return
            
            result, errors = self.convert_asm_to_binary(asm_code)
            original_filename = None
        
        # Mostrar resultados
        if errors:
            self.result_text.insert(1.0, "ERRORES ENCONTRADOS:\n" + "\n".join(errors))
            messagebox.showerror("Error", f"Se encontraron {len(errors)} errores.\nRevise el área de resultados.")
            return
        
        if result:
            # Mostrar preview
            preview = f"Conversión exitosa! {len(result)} instrucciones convertidas.\n\n"
            preview += "Preview (primeras 10 líneas):\n"
            for i, line in enumerate(result[:10], 1):
                if self.output_format.get() == 'asm':
                    preview += f"{i}: {self.binary_to_asm(line)}\n"
                else:
                    preview += f"{i}: {line}\n"
            if len(result) > 10:
                preview += f"... y {len(result) - 10} líneas más\n"
            
            self.result_text.insert(1.0, preview)
            
            # Guardar archivo
            if self.save_output(result, original_filename):
                messagebox.showinfo("Completado", "La conversión se ha completado exitosamente")
    
    def clear_all(self):
        """Limpia todos los campos"""
        self.file_path.set("")
        self.manual_text.delete(1.0, tk.END)
        self.result_text.delete(1.0, tk.END)
        self.input_method.set("file")
        self.toggle_input_method()

if __name__ == "__main__":
    root = tk.Tk()
    app = MIPSConverter(root)
    root.mainloop()
