# utils.py

import psycopg2
import psycopg2.extras


def connectToDB():
  connectionString = 'dbname=chat user=postgres password=Wtr15! host=localhost'
  try:
    return psycopg2.connect(connectionString)
  except:
    print("Can't connect to database")
