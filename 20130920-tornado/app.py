# -*- mode: python; coding: utf-8-with-signature-unix -*-
#=======================================================================================================================

from flask import Flask, render_template
app = Flask(__name__)


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
    app.run(debug=True)

