ALTER TABLE roadnet ADD COLUMN source integer;	--设置起点字段 
ALTER TABLE roadnet ADD COLUMN target integer;	--设置终点字段

ALTER TABLE roadnet ADD COLUMN cost double precision;	--设置起点字段 
ALTER TABLE roadnet ADD COLUMN reverse_cost double precision;	--设置终点字段

UPDATE roadnet SET cost = ST_Length(geom);
UPDATE roadnet SET reverse_cost = ST_Length(geom);

select pgr_createTopology('roadnet', 0.0001,'geom','id');
