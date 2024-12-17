from flask_sqlalchemy import SQLAlchemy
from geoalchemy2 import Geometry

db = SQLAlchemy()

class Lantern(db.Model):
    __tablename__ = 'lantern'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    status = db.Column(db.Boolean)
    geom = db.Column(Geometry(geometry_type='POINT', srid=4326))
    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "status": self.status,
            "geom": self.geom_desc()
        }

    def geom_desc(self):
        # 将 `geom` 转换为 WKT 格式，方便前端使用
        from geoalchemy2.elements import WKTElement
        if self.geom:
            return db.session.scalar(self.geom.ST_AsText())  # 使用 PostGIS 函数返回 WKT
        return None
