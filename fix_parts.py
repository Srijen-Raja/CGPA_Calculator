import os

def fix_parts():
    path = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\home_page.dart'
    with open(path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    new_lines = []
    part_lines = []
    
    for line in lines:
        if line.startswith("part 'overlays_extension.dart';") or line.startswith("part 'main_ui_extension.dart';"):
            if line not in part_lines:
                part_lines.append(line)
        else:
            new_lines.append(line)
            
    # Find last import
    last_import_idx = 0
    for i, line in enumerate(new_lines):
        if line.startswith('import '):
            last_import_idx = i
            
    # Insert exactly after last import
    for p in reversed(part_lines):
        new_lines.insert(last_import_idx + 1, p if p.endswith('\n') else p + '\n')
            
    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
        
    print("Fixed part directives!")

if __name__ == '__main__':
    fix_parts()
