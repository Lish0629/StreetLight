from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

from sqlalchemy import text

from models import db, User
from config import Config
from flask_cors import CORS

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)
CORS(app)

@app.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify([user.to_dict() for user in users])

@app.route('/test',methods=['GET'])
def test():
    return "test"

@app.route('/users', methods=['POST'])
def create_user():
    data = request.json
    new_user = User(name=data['name'], email=data['email'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify(new_user.to_dict()), 201

#生成缓冲区分析图层
@app.route('/generate-lantern-buffer',methods=['POST'])
def generate_lantern_buffer():
    data = request.json
    distance = data.get('distance',1000)

    try:
        with db.session.begin():
            db.session.execute(text('DELETE FROM buffer_result'))
            db.session.execute(text('''
                INSERT INTO buffer_result (id,buffered_gemo)
                SELECT 1,ST_UNION(ST_BUFFER(ST_Transform(geom,3857), :distance))
                FROM lantern
                WHERE status=true
            '''),{'distance':distance})
        return jsonify({'message':'缓冲区生成成功','distance':distance}),201
    except Exception as e:
        print(f"Error:{e}")
        return jsonify({'error':'缓冲区生成失败','details':str(e)}),500


if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # 创建数据库表
    app.run(debug=True)
