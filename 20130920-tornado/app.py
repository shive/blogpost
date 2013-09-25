# -*- mode: python; coding: utf-8-with-signature-unix -*-
#=======================================================================================================================

from flask import Flask, g, render_template, url_for, redirect
from flask_googleauth import GoogleAuth

app = Flask(__name__)
app.secret_key = '59100246e7a512b2f2b3b06594d28a37'
auth = GoogleAuth(app)


#------------------------------------------------------------------------------
@app.route('/')
def index():
    if g.user is None:
        return '<html><body><a href="/login/">need login.</a></body></html>'
    name = g.user['email'].partition('@')[0]
    return redirect(url_for('hello', name=name))


#------------------------------------------------------------------------------
@app.route('/hello/')
@app.route('/hello/<name>/')
def hello(name=None):
    if g.user is None:
        return '<html><body><a href="/login/">need login.</a></body></html>'
    return render_template('index.html', name=name)


#------------------------------------------------------------------------------
@app.route('/favicon.ico')
def favicon():
    return app.send_static_file('favicon.ico')


#------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run(debug=True)

