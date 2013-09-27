# -*- mode: python; coding: utf-8-with-signature-unix -*-
#=======================================================================================================================

from flask import Flask, g, render_template, url_for, redirect
from flask_googleauth import GoogleAuth

app = Flask(__name__)
app.secret_key = '59100246e7a512b2f2b3b06594d28a37'
auth = GoogleAuth(app)


#------------------------------------------------------------------------------
@app.route('/')
@auth.required
def index():
    name = g.user['email'].partition('@')[0]
    return redirect(url_for('hello', name=name))


#------------------------------------------------------------------------------
@app.route('/hello/')
@app.route('/hello/<name>/')
@auth.required
def hello(name=None):
    return render_template('index.html', name=name)


#------------------------------------------------------------------------------
@app.route('/favicon.ico')
def favicon():
    return app.send_static_file('favicon.ico')


#------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run(debug=True)

