import os
import uuid
from flask import Flask, session, render_template, request, redirect, url_for
from flask.ext.socketio import SocketIO, emit

import psycopg2
import psycopg2.extras

import utils

def connectToDB():
  connectionString = 'dbname=chat user=postgres password=Wtr15! host=localhost'
  try:
    return psycopg2.connect(connectionString)
  except:
    print("Can't connect to database")

app = Flask(__name__, static_url_path='')
app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app)

messages = [{'text':'test', 'name':'testName'}]
users = {}

def updateRoster():
    names = []
    for user_id in  users:
        print users[user_id]['username']
        if len(users[user_id]['username'])==0:
            names.append('Anonymous')
        else:
            names.append(users[user_id]['username'])
    print 'broadcasting names'
    emit('roster', names, broadcast=True)
    

@socketio.on('connect', namespace='/chat')
def test_connect():
    session['uuid']=uuid.uuid1()
    session['username']='starter name'
    print 'connected'
    
    users[session['uuid']]={'username':'New User'}
    updateRoster()

    for message in messages:
        emit('message', message)

@socketio.on('message', namespace='/chat')
def new_message(message):
    #tmp = {'text':message, 'name':'testName'}
    #tmp = {'text':message, 'name':users[session['uuid']]['username']}
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    # add new entry into database
    try:
      cur.execute("""INSERT INTO msg (message, user_id) 
       VALUES (%s, %s, %s);""",
       (message, 1) )
    except:
      print("ERROR inserting into messages")
    conn.commit()
  
    """rows returned from postgres are just an ordered list"""
    try:
        cur.execute("select message from msg")
    except:
        print("Error executing select")
    results = cur.fetchall()
    messages.append(results)
    emit('message', results, broadcast=True)
    
@socketio.on('identify', namespace='/chat')
def on_identify(message):
    print 'identify' + message
    users[session['uuid']]={'username':message}
    updateRoster()


@socketio.on('login', namespace='/chat')
def on_login(pw, uname):
    print 'login '  + pw
    
    
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    username = uname
    try:
        query = "SELECT * FROM users WHERE username = '%s' AND password = '%s'" % (username, pw)
        print query
        print cur.execute(query)
        print 'OK'
        if cur.fetchone():
            print 'query worked'
            actualUser=True
        else:
            print 'query did not work'
            actualUser=False
        
        emit('login', actualUser, broadcast=True)
    except:
        print("Incorrect login.  Please try again.")

    
@socketio.on('disconnect', namespace='/chat')
def on_disconnect():
    print 'disconnect'
    if session['uuid'] in users:
        del users[session['uuid']]
        updateRoster()

@app.route('/')
def hello_world():
    print 'in hello world'
    return app.send_static_file('index.html')
    return 'Hello World!'

@app.route('/js/<path:path>')
def static_proxy_js(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('js', path))
    
@app.route('/css/<path:path>')
def static_proxy_css(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('css', path))
    
@app.route('/img/<path:path>')
def static_proxy_img(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('img', path))
    
if __name__ == '__main__':
    print "A"

    socketio.run(app, host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 8080)))
     