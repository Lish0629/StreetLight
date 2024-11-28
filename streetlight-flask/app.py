from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

from sqlalchemy import text

from models import db, Lantern
from config import Config
from flask_cors import CORS

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)
CORS(app)

#路灯信息
@app.route('/lantern', methods=['GET'])
def get_users():
    lanterns = Lantern.query.all()
    return jsonify([lantern.to_dict() for lantern in lanterns])




#生成缓冲区分析图层
@app.route('/generate-lantern-buffer',methods=['POST'])
def generate_lantern_buffer():
    data = request.json
    print(data)
    lantern_dist = data.get('lantern_dist',10)
    build_dist = data.get('build_dist',10)
    try:
        with db.session.begin():
            db.session.execute(text('DELETE FROM buffer_result'))
            db.session.execute(text('''
                INSERT INTO buffer_result (buffered_gemo)
                SELECT ST_UNION(lantern_geom, building_geom)
                FROM (
                SELECT ST_UNION(ST_BUFFER(st_transform(geom,3857), :lantern_dist)) AS lantern_geom
                FROM lantern
	            WHERE status=true
                ) AS lantern_buffered,
                (
                    SELECT ST_UNION(ST_BUFFER(geom, :build_dist)) AS building_geom
                    FROM building
                ) AS building_buffered;
            '''),{'lantern_dist':lantern_dist,'build_dist':build_dist})
        return jsonify({'message':'缓冲区生成成功','lantern_dist':lantern_dist,'build_dist':build_dist}),201
    except Exception as e:
        print(f"Error:{e}")
        return jsonify({'error':'缓冲区生成失败','details':str(e)}),500

@app.route('/generate-path', methods=['POST'])
def generate_path():
    data = request.json
    print(data)

    lat1 = data.get('lat1', 3536711.1)
    lat2 = data.get('lat2', 3537602.8)
    lon1 = data.get('lon1', 13327894.0)
    lon2 = data.get('lon2', 13327141.7)

    try:
        with db.session.begin():
            db.session.execute(text('DELETE FROM paths'))
            result = db.session.execute(text('''
                WITH 
            start_node AS (
                SELECT id AS closest_node,
                       the_geom AS start_geom
                FROM roadnet_vertices_pgr
                ORDER BY ST_Distance(
                    the_geom,  -- 不需要转换，直接使用 SRID 3857
                    ST_SetSRID(ST_MakePoint(:lon1, :lat1), 3857)  -- 起点坐标使用 SRID 3857
                )
                LIMIT 1
            ),
            end_node AS (
                SELECT id AS closest_node,
                       the_geom AS end_geom
                FROM roadnet_vertices_pgr
                ORDER BY ST_Distance(
                    the_geom,  -- 不需要转换，直接使用 SRID 3857
                    ST_SetSRID(ST_MakePoint(:lon2, :lat2), 3857)  -- 终点坐标使用 SRID 3857
                )
                LIMIT 1
            ),
            dijkstra_path AS (
                SELECT edge, cost
                FROM pgr_dijkstra(
                    'SELECT id, source, target, cost, reverse_cost FROM roadnet',
                    (SELECT closest_node FROM start_node),
                    (SELECT closest_node FROM end_node),
                    false
                )
                WHERE edge != -1
            ),
            path_geom AS (
                SELECT ST_Union(geom) AS pgeom,
                       SUM(cost) AS total_cost
                FROM roadnet
                WHERE id IN (SELECT edge FROM dijkstra_path)
            )
            INSERT INTO paths (start_point, end_point, start_node, end_node, path, total_cost)
            SELECT 
                (SELECT start_geom FROM start_node) AS start_point,
                (SELECT end_geom FROM end_node) AS end_point,
                (SELECT closest_node FROM start_node) AS start_node,
                (SELECT closest_node FROM end_node) AS end_node,
                path_geom.pgeom AS path,
                path_geom.total_cost AS total_cost
            FROM path_geom;

            '''), {'lon1': lon1, 'lat1': lat1, 'lat2': lat2, 'lon2': lon2})

            # 获取查询结果



        return jsonify({
            'message': '路径生成成功',

        }), 201

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': '路径生成失败', 'details': str(e)}), 500

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # 创建数据库表
    app.run(debug=True)
