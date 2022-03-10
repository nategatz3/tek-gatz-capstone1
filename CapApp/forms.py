from flask_wtf import FlaskForm
from wtforms import StringField, IntegerField, SubmitField, SelectField
from wtforms.validators import DataRequired, InputRequired

class AddSalesForm(FlaskForm):

    ### Allows us to select from current Sales Team Leads ###
    emp_id = SelectField(u'Employee ID: ',
                        choices=[('EMP234','EMP234'),('EMP244','EMP244'),('EMP256','EMP256'),('EMP267','EMP267'),('EMP290','EMP290')])
    ### Allows us to select from current Products ###
    prod_code = SelectField(u'Product Code: ',
                            choices=[('PROD_001','PROD_001'),('PROD_002','PROD_002'),('PROD_003','PROD_003'),('PROD_004','PROD_004'),
                            ('PROD_005','PROD_005'),('PROD_006','PROD_006'),('PROD_007','PROD_007'),('PROD_008','PROD_008')])
    ### Number of product sold in any particular week ###
    prod_quantity = IntegerField('Quantity of Product Sold: ',validators=[DataRequired(),InputRequired()])
    ### Allows us to select current Service Plans ###
    serv_plan = SelectField(u'Service Plan: ',
                            choices=[('ESP_001','ESP_001'),('ESP_002','ESP_002'),('ESP_003','ESP_003'),('ESP_004','ESP_004'),
                            ('ESP_005','ESP_005'),('ESP_006','ESP_006'),('ESP_007','ESP_007'),('ESP_008','ESP_008')])
    ### Number of Service Plans sold in any particular week ###
    serv_quantity = IntegerField('Quanity of Service Plans Sold: ')
    ### Allows for precise selection of weeks 1-52 ###
    the_week = SelectField(u'Week of Sale: ',
                            choices=[('1','1'),('2','2'),('3','3'),('4','4'),('5','5'),('6','6'),('7','7'),('8','8'),('9','9'),('10','10'),('11','11'),('12','12'),('13','13'),('14','14'),
                            ('15','15'),('16','16'),('17','17'),('18','18'),('19','19'),('20','20'),('21','21'),('22','22'),('23','23'),('24','24'),('25','25'),('26','26'),('27','27'),('28','28'),('29','29'),
                            ('30','30'),('31','31'),('32','32'),('33','33'),('34','34'),('35','35'),('36','36'),('37','37'),('38','38'),('39','39'),('40','40'),('41','41'),('42','42'),('43','43'),('44','44'),
                            ('45','45'),('46','46'),('47','47'),('48','48'),('49','49'),('50','50'),('51','51'),('52','52')])
    ### Allows for precise input of the year ###
    the_year = SelectField(u'Year of Sale: ',
                            choices=[('2021','2021'),('2022','2022'),('2023','2023')])
    submit = SubmitField('Submit Sale')

class DelForm(FlaskForm):

    id = IntegerField('Id Number of Sale: ')
    submit = SubmitField('Remove Sale')
