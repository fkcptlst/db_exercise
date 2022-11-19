import os
from tqdm import tqdm

data_root = '../data'
forums_list = os.listdir(data_root)
data_table_list = os.listdir(os.path.join(data_root, forums_list[0]))

for data_table in tqdm(data_table_list, leave=False):
    for i, forum in enumerate(forums_list):
        assert os.path.exists(os.path.join(data_root, forum, data_table)), \
            f'File {data_table} does not exist in {forum} forum'
    with open(os.path.join(data_root, data_table), 'w', encoding='utf-8') as ofile:
        for i, forum in enumerate(forums_list):
            print(f'Processing "{forum}" forum, field id {i + 1}, table "{data_table}"')
            with open(os.path.join(data_root, forum, data_table), 'r', encoding='utf-8') as infile:
                lines = infile.readlines()
                # skip header
                lines = lines[1:]
                for line in lines:
                    # if line ends with newline, keep it, otherwise add newline
                    if line[-1] == '\n':
                        ofile.write(f"{i + 1},{line}")
                    else:
                        ofile.write(f"{i + 1},{line}\n")
