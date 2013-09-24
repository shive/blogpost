# -*- mode: python; coding: utf-8-with-signature-unix -*-
#=======================================================================================================================

from flask import Flask, render_template, url_for, redirect
app = Flask(__name__)


#------------------------------------------------------------------------------
@app.route('/')
def index():
    return redirect(url_for('hello'))


#------------------------------------------------------------------------------
@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('index.html', name=name)


#------------------------------------------------------------------------------
@app.route('/favicon.ico')
def favicon():
    return app.send_static_file('favicon.ico')


#------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

