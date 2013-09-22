# -*- mode: python; coding: utf-8-with-signature-unix -*-
#=======================================================================================================================

import os
from flask import Flask, send_from_directory
app = Flask(__name__)


#------------------------------------------------------------------------------
@app.route('/')
def hello():
    return 'Hello World!!'

# #------------------------------------------------------------------------------
# @app.route('/favicon.ico')
# def favicon():
#     app.logger.debug('app.root_path: %s' % app.root_path)
#     return send_from_directory(
#         os.path.join(app.root_path, 'static'),
#         'favicon.ico',
#         as_attachment = True,
#         )

#------------------------------------------------------------------------------
if __name__ == '__main__':
    app.run(debug=True)

