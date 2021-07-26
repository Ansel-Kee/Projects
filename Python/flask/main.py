from flask import *
import json
   
app = Flask(__name__)

with open('orders.json') as f:
    orders = json.load(f)
with open('passwords.json') as f1:
    passwords = json.load(f1)

@app.route('/')
def index():
    prev = request.url_rule.rule
    print(prev)
    resp = make_response(render_template('home.html', origin = prev))
    resp.set_cookie('referrer', prev)
    return resp

@app.route('/success/<name>')
def success(name):
    prev = request.cookies.get('referrer')
    print(prev, prev.rule)
    resp = make_response(render_template('success.html', origin = prev, user = name))
    resp.set_cookie('userID', name)
    if name not in orders:
        orders[name] = {'Apples': 0, 'Oranges': 0, 'Pears': 0}
        with open('orders.json', 'w') as f:
            json.dump(orders, f)  
    resp.set_cookie('order', json.dumps(orders[name]))
    resp.set_cookie('referrer', request.url_rule.rule)
    return resp

@app.route('/failed/<user_check>')
def failed(user_check):
    prev = request.cookies.get('referrer')
    resp = make_response(render_template('failed.html', found = user_check, origin = prev))
    resp.set_cookie('referrer', request.url_rule.rule)
    return resp

@app.route('/register')
def register():
    prev = request.cookies.get('referrer')
    
    resp = make_response(render_template('failed.html', origin = prev))
    resp.set_cookie('referrer', request.url_rule.rule)
    return resp

@app.route('/signup', methods = ['POST'])
def signup():
    user = request.form['nm']
    password = request.form['pw']
    passwords[user] = password
    with open('passwords.json', 'w') as f:
        json.dump(passwords, f)    
    return redirect(f'/success/{user}')

@app.route('/logon')
def logon():
    prev = request.cookies.get('referrer')
    resp = make_response(render_template('failed.html', found = user_check, origin = prev))
    resp.set_cookie('referrer', request.url_rule.rule)
    return resp

@app.route('/login',methods = ['POST'])
def login():
    user = request.form['nm']
    password = request.form['pw']
    if user not in passwords:
        return redirect('/failed/n')
    elif passwords[user] != password:
        return redirect('/failed/y')
    return redirect(f'/success/{user}')

@app.route('/users')
def user_log():
    prev = request.cookies.get('referrer')
    resp = make_response(render_template('failed.html', found = user_check, origin = prev))
    resp.set_cookie('referrer', request.url_rule.rule)
    return resp   

@app.route('/fruits')
def fruits():
    prev = request.cookies.get('referrer')
    resp = make_response(render_template('fruits.html', order=orders[user], origin = prev))
    user = request.cookies.get('userID')
    prev = request.cookies.get('referrer')
    resp.set_cookie('referrer', request.url_rule.rule)
    return resp

@app.route('/save', methods = ['POST'])
def save():
    order = json.loads(request.get_data().decode('utf-8'))
    user = request.cookies.get('userID')
    orders[user] = order
    with open('orders.json', 'w') as f:
        json.dump(orders, f)  
    return redirect('/fruits')

if __name__ == '__main__':
     app.run(debug = True, host="0.0.0.0", port=8080)
