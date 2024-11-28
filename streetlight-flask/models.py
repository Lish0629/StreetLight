from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Lantern(db.Model):
    __tablename__ = 'lantern'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80))
    status = db.Column(db.Boolean)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "status": self.status
        }
