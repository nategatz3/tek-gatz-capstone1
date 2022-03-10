import os
from forms import  AddSalesForm , DelForm
from flask import Flask, render_template, url_for, redirect
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SECRET_KEY'] = 'mysecretkey'

############################################

        # SQL DATABASE AND MODELS

##########################################
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:Password123@localhost/tractortek'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
Migrate(app,db)

class Sales(db.Model):

    __tablename__ = 'oltp_weekly_sales'
    sale_id = db.Column(db.Integer,primary_key = True)
    emp_id = db.Column(db.Text)
    prod_code = db.Column(db.Text)
    prod_quantity = db.Column(db.Integer)
    serv_plan = db.Column(db.Text)
    serv_quantity = db.Column(db.Integer)
    the_week = db.Column(db.Integer)
    the_year = db.Column(db.Integer)

    def __init__(self,emp_id,prod_code,prod_quantity,serv_plan,serv_quantity,the_week,the_year):
        self.emp_id = emp_id
        self.prod_code = prod_code
        self.prod_quantity = prod_quantity
        self.serv_plan = serv_plan
        self.serv_quantity = serv_quantity
        self.the_week = the_week
        self.the_year = the_year

    def __repr__(self):
        if self.serv_quantity == 0:
            return f"{self.emp_id} sold {self.prod_quantity} unit(s) of {self.prod_code} in Week {self.the_week} of {self.the_year}. No units of the corresponding warranty were sold."
        else:
            return f"{self.emp_id} sold {self.prod_quantity} unit(s) of {self.prod_code}, as well as {self.serv_quantity} unit(s) of the extended warranty ({self.serv_plan}), in Week {self.the_week} of {self.the_year}."

db.create_all()
############################################

        # VIEWS WITH FORMS

##########################################
@app.route('/')
def index():
    return render_template('home.html')

@app.route('/add_sale', methods=['GET', 'POST'])
def add_sale():
    form = AddSalesForm()

    if form.validate_on_submit():
        emp_id = form.emp_id.data
        prod_code = form.prod_code.data
        prod_quantity = form.prod_quantity.data
        serv_plan = form.serv_plan.data
        serv_quantity = form.serv_quantity.data
        the_week = form.the_week.data
        the_year = form.the_year.data

        # Adds Sales to db
        new_sale = Sales(emp_id,prod_code,prod_quantity,serv_plan,serv_quantity,the_week,the_year)
        db.session.add(new_sale)
        db.session.commit()

        return redirect(url_for('list_sale'))

    return render_template('add_sale.html',form=form)

@app.route('/list')
def list_sale():
    # Shows all the Sales in the db
    allsales = Sales.query.all()
    return render_template('list_sales.html', allsales=allsales)

@app.route('/delete', methods=['GET', 'POST'])
def del_sale():

    form = DelForm()

    if form.validate_on_submit():
        id = form.id.data
        delsale = Sales.query.get(id)
        db.session.delete(delsale)
        db.session.commit()

        return redirect(url_for('list_sale'))
    return render_template('delete.html',form=form)


if __name__ == '__main__':
    app.run(debug=True)
