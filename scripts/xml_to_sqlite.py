import re
import sqlite3
import time
import datetime
import os
from tqdm import tqdm
import xml.etree.ElementTree as ET

"""
The following schema is based on the specification mentioned here https://ia800107.us.archive.org/27/items/stackexchange/readme.txt
"""

database_dir = "../database_data"
database_file = os.path.join(database_dir, "mathoverflow.stackexchange.db")
xml_dir = os.path.join(database_dir, "xml_data")

## column dicts ------------------------------------------------------------
badges_columns_dict = {"Id": "INTEGER PRIMARY KEY",
                       "UserId": "INTEGER",
                       "Name": "TEXT",
                       "Date": "INTEGER",
                       "Class": "INTEGER",
                       "TagBased": "TEXT"}

comments_columns_dict = {"Id": "INTEGER PRIMARY KEY",
                         "PostId": "INTEGER",
                         "Score": "INTEGER",
                         "Text": "TEXT",
                         "CreationDate": "INTEGER",
                         "UserDisplayName": "TEXT",
                         "UserId": "INTEGER1",
                         "ContentLicense": "TEXT"}

posthistory_columns_dict = {'Id': 'INTEGER PRIMARY KEY',
                            'PostHistoryTypeId': 'INTEGER',
                            'PostId': 'INTEGER',
                            'RevisionGUID': 'TEXT',
                            'CreationDate': 'INTEGER',
                            'UserId': 'INTEGER',
                            'Text': 'TEXT',
                            'ContentLicense': 'TEXT',
                            'Comment': 'TEXT',
                            'UserDisplayName': 'TEXT'}

postlinks_columns_dict = {"Id": "INTEGER PRIMARY KEY",
                          "CreationDate": "INTEGER",
                          "PostId": "INTEGER",
                          "RelatedPostId": "INTEGER",
                          "LinkTypeId": "INTEGER"}

posts_columns_dict = {'Id': 'INTEGER PRIMARY KEY',
                      'PostTypeId': 'INTEGER',
                      'AcceptedAnswerId': 'INTEGER',
                      'CreationDate': 'INTEGER',
                      'Score': 'INTEGER',
                      'ViewCount': 'INTEGER',
                      'Body': 'TEXT',
                      'OwnerUserId': 'INTEGER',
                      'LastEditorUserId': 'INTEGER',
                      'LastEditDate': 'INTEGER',
                      'LastActivityDate': 'INTEGER',
                      'Title': 'TEXT',
                      'Tags': 'TEXT',
                      'AnswerCount': 'INTEGER',
                      'CommentCount': 'INTEGER',
                      'FavoriteCount': 'INTEGER',
                      'ContentLicense': 'TEXT',
                      'ParentId': 'INTEGER',
                      'ClosedDate': 'INTEGER',
                      'CommunityOwnedDate': 'INTEGER',
                      'LastEditorDisplayName': 'TEXT',
                      'OwnerDisplayName': 'TEXT'}

tags_columns_dict = {'Id': 'INTEGER PRIMARY KEY',
                     'TagName': 'TEXT',
                     'Count': 'INTEGER',
                     'ExcerptPostId': 'INTEGER',
                     'WikiPostId': 'INTEGER'}

users_columns_dict = {'Id': 'INTEGER PRIMARY KEY',
                      'Reputation': 'INTEGER',
                      'CreationDate': 'INTEGER',
                      'DisplayName': 'TEXT',
                      'LastAccessDate': 'INTEGER',
                      'Location': 'TEXT',
                      'AboutMe': 'TEXT',
                      'Views': 'INTEGER',
                      'UpVotes': 'INTEGER',
                      'DownVotes': 'INTEGER',
                      'AccountId': 'INTEGER',
                      'ProfileImageUrl': 'TEXT',
                      'WebsiteUrl': 'TEXT'}

votes_columns_dict = {'Id': 'INTEGER PRIMARY KEY',
                      'PostId': 'INTEGER',
                      'VoteTypeId': 'INTEGER',
                      'CreationDate': 'INTEGER',
                      'UserId': 'INTEGER',
                      'BountyAmount': 'INTEGER'}


def get_initial_sql(table_name, table_columns_dict):
    _sql = f"CREATE TABLE IF NOT EXISTS {table_name} ("
    for column_name, column_type in table_columns_dict.items():
        _sql += f"{column_name} {column_type}, "
    _sql = _sql[:-2] + ")"
    return _sql


create_badges = get_initial_sql("badges", badges_columns_dict)
create_comments = get_initial_sql("comments", comments_columns_dict)
create_posthistory = get_initial_sql("posthistory", posthistory_columns_dict)
create_postlinks = get_initial_sql("postlinks", postlinks_columns_dict)
create_posts = get_initial_sql("posts", posts_columns_dict)
create_tags = get_initial_sql("tags", tags_columns_dict)
create_users = get_initial_sql("users", users_columns_dict)
create_votes = get_initial_sql("votes", votes_columns_dict)


# export sql to a file
def export_sql(sql, table_name, file_name):
    with open(file_name, "a") as f:
        f.write(f'-- {table_name} \n')
        f.write(sql)
        f.write(";\n")


with open("../SQLs/creates/create_tables.sql", "w") as f:
    f.write("-- create tables \n")
export_sql(create_badges, "badges", "../SQLs/creates/create_tables.sql")
export_sql(create_comments, "comments", "../SQLs/creates/create_tables.sql")
export_sql(create_posthistory, "posthistory", "../SQLs/creates/create_tables.sql")
export_sql(create_postlinks, "postlinks", "../SQLs/creates/create_tables.sql")
export_sql(create_posts, "posts", "../SQLs/creates/create_tables.sql")
export_sql(create_tags, "tags", "../SQLs/creates/create_tables.sql")
export_sql(create_users, "users", "../SQLs/creates/create_tables.sql")
export_sql(create_votes, "votes", "../SQLs/creates/create_tables.sql")

"""
The extracted xml files must be in the same directory as this script for the converion to work properly.
Also the xml filenames should conform to the names mentioned below in the `data_files` dict.

"""

create_tables = [create_users, create_tags, create_posts, create_posthistory, create_postlinks, create_comments,
                 create_badges, create_votes]
data_files = {'badges': "Badges.xml", 'comments': "Comments.xml", 'posts': "Posts.xml",
              'posthistory': "PostHistory.xml", 'postlinks': "PostLinks.xml", 'tags': "Tags.xml", 'users': "Users.xml",
              'votes': "Votes.xml"}
schema = {'badges': (create_badges, badges_columns_dict),
          'comments': (create_comments, comments_columns_dict),
          'posts': (create_posts, posts_columns_dict),
          'posthistory': (create_posthistory, posthistory_columns_dict),
          'postlinks': (create_postlinks, postlinks_columns_dict),
          'tags': (create_tags, tags_columns_dict),
          'users': (create_users, users_columns_dict),
          'votes': (create_votes, votes_columns_dict)}

"""
Columns with the following names (as in the `dates` list) will be converted to unix timestamp during conversion..
"""


def get_timestamp(time_str):
    return time.mktime(datetime.datetime.strptime(time_str, "%Y-%m-%dT%H:%M:%S.%f").timetuple())


conn = sqlite3.connect(database_file)

schema_iter = tqdm(schema.items())
for idx, (table, (create_table_sql, column_dict)) in enumerate(schema_iter):
    schema_iter.set_description(f"Creating table ({table})")

    c = conn.cursor()
    c.execute(create_table_sql)

    # print("Executed:", schema[table])  # debug

    xml_file = os.path.join(xml_dir, data_files[table])
    tree = ET.parse(xml_file)
    root = tree.getroot()
    for line in root:
        # for key, value in line.attrib.items():
        #     print(f"{key} = {value}")
        sql = "INSERT INTO " + table + " ( "
        values_dict = {}
        for key, _ in column_dict.items():  # initialize all values to None
            values_dict[key] = None
        # the keys of values_dict is same as column_dict

        for key, value in line.attrib.items():
            if key in column_dict.keys():
                if re.findall(r"date|Date", key):  # if the key is a date
                    values_dict[key] = get_timestamp(value)
                else:
                    values_dict[key] = value
            else:
                raise Exception(f"Key: ({key}) not found in column_dict, column_dict: {column_dict}, table: {table}")

        cols = list(column_dict.keys())
        vals = [values_dict[col] for col in cols]
        sql += ','.join(cols) + " ) VALUES ( " + ','.join('?' * len(vals)) + " )"

        # print(f'sql: {sql}, vals: {vals} \n')  # debug

        c.execute(sql, vals)

conn.commit()
conn.close()
print("Done")
