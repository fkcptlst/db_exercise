import xml.etree.ElementTree as ET
import os

xml_path = os.path.join('database_data', 'xml_data', 'PostLinks.xml')

def get_all_attr(xml_path):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    attr_list = []
    for child in root:
        for attr in child.attrib:
            if attr not in attr_list:
                attr_list.append(attr)
    return attr_list

attr_list = get_all_attr(xml_path)
attr_dict = {}
for attr in attr_list:
    attr_dict[attr] = None
print(attr_dict)
