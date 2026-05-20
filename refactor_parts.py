import os
import re

def get_balanced_block(text, start_index, open_char='(', close_char=')'):
    stack = 0
    in_string = False
    string_char = None
    i = start_index
    
    while i < len(text) and text[i] != open_char:
        i += 1
        
    if i >= len(text): return None
    
    start_pos = i
    stack = 1
    i += 1
    
    while i < len(text) and stack > 0:
        c = text[i]
        
        if not in_string and (c == '"' or c == "'"):
            in_string = True
            string_char = c
        elif in_string and c == string_char:
            if text[i-1] != '\\':
                in_string = False
        
        if not in_string:
            if c == open_char:
                stack += 1
            elif c == close_char:
                stack -= 1
        i += 1
        
    if stack == 0:
        return i
    return None

def main():
    home_page_path = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\home_page.dart'
    
    with open(home_page_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    stack_match = re.search(r'body:\s*Stack\(\s*children:\s*\[', content)
    if not stack_match:
        print("Could not find Stack in body")
        return
        
    # The first child is Center(. Let's extract that.
    center_start = content.find('Center(', stack_match.end())
    center_end = get_balanced_block(content, center_start, '(', ')')
    
    center_block = content[center_start:center_end]
    content = content[:center_start] + "buildMainUI(wid, hei)" + content[center_end:]
    
    # After Center is extracted, the string is much smaller.
    # The overlays are now directly after `buildMainUI(wid, hei),`
    
    extracts = []
    
    def extract_overlay(name, method_name, search_str):
        nonlocal content
        # search from the beginning each time because we know they are in the Stack
        start = content.find(search_str, stack_match.start())
        if start != -1:
            end = get_balanced_block(content, start, '(', ')')
            if end:
                block = content[start:end]
                content = content[:start] + f"{method_name}(wid, hei)" + content[end:]
                extracts.append((name, method_name, block))
                return True
        return False
        
    # course detail (AnimatedSwitcher)
    # search (AnimatedSwitcher)
    # add course (AnimatedScale)
    # fab (AnimatedPositioned)
    
    # Since there are two AnimatedSwitchers, let's extract by looking for "AnimatedSwitcher" twice
    extract_overlay('course_detail', 'buildCourseDetailSheet', 'AnimatedSwitcher(')
    extract_overlay('search_overlay', 'buildSearchOverlay', 'AnimatedSwitcher(')
    extract_overlay('add_course_dialog', 'buildAddCourseDialog', 'AnimatedScale(')
    extract_overlay('fab_overlay', 'buildFabOverlay', 'AnimatedPositioned(')
    
    ext_content = "part of 'home_page.dart';\\n\\nimport 'package:flutter/material.dart';\\n\\nextension OverlaysExtension on _MyHomePageState {\\n"
    for name, method_name, block in extracts:
        ext_content += f"  Widget {method_name}(double wid, double hei) {{\n    return {block};\n  }}\n\n"
    ext_content += "}\\n"
    
    with open(r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\overlays_extension.dart', 'w', encoding='utf-8') as f:
        f.write(ext_content)
        
    # Main UI
    ext2_content = "part of 'home_page.dart';\\n\\nimport 'package:flutter/material.dart';\\n\\nextension MainUiExtension on _MyHomePageState {\\n"
    ext2_content += f"  Widget buildMainUI(double wid, double hei) {{\n    return {center_block};\n  }}\n"
    ext2_content += "}\\n"

    with open(r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib\main_ui_extension.dart', 'w', encoding='utf-8') as f:
        f.write(ext2_content)
        
    # Inject parts
    lines = content.split('\\n')
    insert_idx = 0
    for i, line in enumerate(lines):
        if line.startswith('import '):
            insert_idx = i
            
    lines.insert(insert_idx + 1, "part 'overlays_extension.dart';")
    lines.insert(insert_idx + 2, "part 'main_ui_extension.dart';")
    
    with open(home_page_path, 'w', encoding='utf-8') as f:
        f.write('\\n'.join(lines))
        
    print(f"Extraction successful! Extracted {len(extracts)} overlays and 1 main UI.")

if __name__ == '__main__':
    main()
