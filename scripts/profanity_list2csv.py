list_path = '../profanity_list.txt'
csv_path = '../profanity_list.csv'
with open(list_path) as list_file:
    with open(csv_path, 'w') as csv_file:
        for i,line in enumerate(list_file):
            csv_file.write(f'{i+1},{line.strip()}\n')
