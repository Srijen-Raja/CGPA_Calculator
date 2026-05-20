import os

main_path = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\main.dart'
home_page_path = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\home_page.dart'

with open(main_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# find where "class MyHomePage" starts
start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('class MyHomePage extends StatefulWidget'):
        start_idx = i
        break

if start_idx != -1:
    main_code = lines[:start_idx]
    home_page_code = lines[start_idx:]
    
    # We need to add imports to home_page.dart
    imports = []
    for line in main_code:
        if line.startswith('import ') or line.startswith('//'):
            imports.append(line)
            
    # The imports required for home_page.dart are mostly the same as main.dart
    with open(home_page_path, 'w', encoding='utf-8') as f:
        f.writelines(imports)
        f.write("\n")
        f.writelines(home_page_code)
        
    # main.dart needs to import home_page.dart
    # Let's clean up main.dart
    new_main_code = []
    for line in main_code:
        new_main_code.append(line)
    
    # Add import for home_page
    insert_import_idx = 0
    for i, line in enumerate(new_main_code):
        if line.startswith('import '):
            insert_import_idx = i
            
    new_main_code.insert(insert_import_idx + 1, "import 'package:cgpa_calculator/home_page.dart';\n")
            
    with open(main_path, 'w', encoding='utf-8') as f:
        f.writelines(new_main_code)
        
    print(f"Moved {len(home_page_code)} lines to home_page.dart")
else:
    print("Could not find MyHomePage in main.dart")
