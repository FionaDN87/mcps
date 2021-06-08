# import mysql.connector

# mydb = mysql.connector.connect(
#  host="localhost",
#  user="yourusername",
#  password="yourpassword",
#  database="mydatabase"
)

#  mycursor = mydb.cursor()

#  mycursor.execute("SELECT * FROM customers")

#  myresult = mycursor.fetchall()

#  for x in myresult:
#  print(x)

import requests

resp = requests.get('http://localhost:3001/readSensorData')
if resp.status_code != 200:
    # This means something went wrong.
    print('GET /readSensorData/ {}'.format(resp.status_code))

# print(resp.json())

for data_item in resp.json();
    for data in data_item.json();
        print(data);