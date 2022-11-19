import os

def create_symlink(source, link_name):
    if os.path.exists(link_name):
        os.remove(link_name)
    os.symlink(source, link_name)

if __name__ == '__main__':
    create_symlink(r'G:\stackexchange\MathOverflow', 'database_data')