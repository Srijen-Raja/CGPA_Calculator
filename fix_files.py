import os

def fix_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace literal '\\n' with actual newline
    content = content.replace('\\n', '\n')
    
    # Remove illegal imports in parts
    if 'extension.dart' in path:
        content = content.replace("import 'package:flutter/material.dart';\n", "")
        content = content.replace("import 'package:flutter/material.dart';\n\n", "")
        
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Fixed {path}")

def main():
    base_dir = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib'
    fix_file(os.path.join(base_dir, 'home_page.dart'))
    fix_file(os.path.join(base_dir, 'overlays_extension.dart'))
    fix_file(os.path.join(base_dir, 'main_ui_extension.dart'))

if __name__ == '__main__':
    main()
