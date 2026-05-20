import os

main_path = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\main.dart'
script_path = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\script.dart'

with open(main_path, 'r', encoding='utf-8') as f:
    main_lines = f.readlines()

# find sgcalc
start_idx = -1
end_idx = -1
for i, line in enumerate(main_lines):
    if 'double sgcalc(String s) {' in line:
        start_idx = i
        break
for i in range(start_idx, len(main_lines)):
    if '  @override' in main_lines[i] and 'Widget build(BuildContext context)' in main_lines[i+1]:
        end_idx = i
        break

if start_idx != -1 and end_idx != -1:
    extracted_lines = main_lines[start_idx:end_idx]
    # Remove one layer of indentation
    extracted_lines = [line[2:] if line.startswith('  ') else line for line in extracted_lines]
    
    # Clean main.dart
    new_main = main_lines[:start_idx] + main_lines[end_idx:]
    with open(main_path, 'w', encoding='utf-8') as f:
        f.writelines(new_main)
        
    print(f"Extracted {len(extracted_lines)} lines from main.dart")

    # insert into script.dart
    with open(script_path, 'r', encoding='utf-8') as f:
        script_lines = f.readlines()
        
    insert_idx = -1
    for i, line in enumerate(script_lines):
        if 'var thm = themes.firstWhere' in line:
            insert_idx = i
            break
            
    if insert_idx != -1:
        new_script = script_lines[:insert_idx] + extracted_lines + script_lines[insert_idx:]
        with open(script_path, 'w', encoding='utf-8') as f:
            f.writelines(new_script)
        print(f"Inserted into script.dart at line {insert_idx}")
    else:
        print("Could not find insert point in script.dart")
else:
    print("Could not find extraction bounds in main.dart")
