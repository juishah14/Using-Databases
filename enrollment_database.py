# Assignment from Coursera's Using Databases with Python
# For this assignment, you must write a program to build a set of tables using the Many-to-Many approach to store enrollment and role data.
# This application will read enrollment/role data in JSON format, parse the file, and then produce an SQLite database that 
# contains a User, Course, and Member table, and populate the tables from the data file. 

import json
import sqlite3

conn = sqlite3.connect('enrollment.sqlite')
cur = conn.cursor()

# Create User, Course, Member tables and drop the tables if they already exist
cur.executescript('''
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Course;
CREATE TABLE User (
    id     INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    name   TEXT UNIQUE
);
CREATE TABLE Course (
    id     INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    title  TEXT UNIQUE
);
CREATE TABLE Member (
    user_id     INTEGER,
    course_id   INTEGER,
    role        INTEGER,
    PRIMARY KEY (user_id, course_id)
)
''')

fname = 'enrollment_info.json'

# Format: [ "Kian", "si110", 1 ]

str_data = open(fname).read()
json_data = json.loads(str_data)

for entry in json_data:

    name = entry[0];
    title = entry[1];
    role = entry[2];

    print((name, title, role))

    cur.execute('''INSERT OR IGNORE INTO User (name)
        VALUES ( ? )''', ( name, ) )
    cur.execute('SELECT id FROM User WHERE name = ? ', (name, ))
    user_id = cur.fetchone()[0]

    cur.execute('''INSERT OR IGNORE INTO Course (title)
        VALUES ( ? )''', ( title, ) )
    cur.execute('SELECT id FROM Course WHERE title = ? ', (title, ))
    course_id = cur.fetchone()[0]

    cur.execute('''INSERT OR REPLACE INTO Member
        (user_id, course_id, role) VALUES ( ?, ?, ? )''',
        ( user_id, course_id, role ) )

    # commit (copy) all data into database
    conn.commit()