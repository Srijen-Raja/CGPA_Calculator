import os

def fix_sitems():
    base_dir = r'c:\Users\srije\StudioProjects\CGPA_Calculator\lib'
    
    # 1. Update home_page.dart calls
    hp_path = os.path.join(base_dir, 'home_page.dart')
    with open(hp_path, 'r', encoding='utf-8') as f:
        hp = f.read()
        
    replacements = [
        ('buildMainUI(wid, hei)', 'buildMainUI(wid, hei, sitems)'),
        ('buildCourseDetailSheet(wid, hei)', 'buildCourseDetailSheet(wid, hei, sitems)'),
        ('buildSearchOverlay(wid, hei)', 'buildSearchOverlay(wid, hei, sitems)'),
        ('buildAddCourseDialog(wid, hei)', 'buildAddCourseDialog(wid, hei, sitems)'),
        ('buildFabOverlay(wid, hei)', 'buildFabOverlay(wid, hei, sitems)')
    ]
    for old, new in replacements:
        hp = hp.replace(old, new)
        
    with open(hp_path, 'w', encoding='utf-8') as f:
        f.write(hp)
        
    # 2. Update the two extension files
    for ext_file in ['main_ui_extension.dart', 'overlays_extension.dart']:
        path = os.path.join(base_dir, ext_file)
        with open(path, 'r', encoding='utf-8') as f:
            ext = f.read()
            
        ext = ext.replace('(double wid, double hei) {', '(double wid, double hei, List<Course> sitems) {')
        
        # Add ignore for setState
        ignore_string = "// ignore_for_file: invalid_use_of_protected_member\n"
        if ignore_string not in ext:
            lines = ext.split('\n')
            lines.insert(1, ignore_string)
            ext = '\n'.join(lines)
            
        with open(path, 'w', encoding='utf-8') as f:
            f.write(ext)
            
    print("Fixed sitems and setState warnings!")

if __name__ == '__main__':
    fix_sitems()
