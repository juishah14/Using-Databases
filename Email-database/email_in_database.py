# Assignment from Coursera's Using Databases with Python
# For this assignment, we must parse a mail text file (mbox.txt) and count the number of emails per organization (by domain of email address)
# and store the email counts in a database using SQLite.

import sqlite3

conn = sqlite3.connect("EmailCounts.sqlite")
cur = conn.cursor()

fh = open("mbox.txt")

cur.execute("DROP TABLE IF EXISTS Counts")
cur.execute("CREATE TABLE Counts (org TEXT, count INTEGER)")

for line in fh:
    if line.startswith("From:"):
        domain = line.split()[1].split("@")[1]
        cur.execute('SELECT count FROM Counts WHERE org = ? ', (domain, ))
        if cur.fetchone() is None:
            cur.execute("INSERT INTO Counts (org, count) VALUES ( ?, 1 )", (domain, ))
        else:
            cur.execute("UPDATE Counts SET count = count + 1 WHERE org = ?", (domain, ))

# commit (copy) all data into database 
conn.commit()
conn.close()