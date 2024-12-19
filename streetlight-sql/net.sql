

ALTER TABLE roadnet ADD COLUMN source integer;	--设置起点字段 
ALTER TABLE roadnet ADD COLUMN target integer;	--设置终点字段

ALTER TABLE roadnet ADD COLUMN cost double precision;	--设置起点字段 
ALTER TABLE roadnet ADD COLUMN reverse_cost double precision;	--设置终点字段

UPDATE roadnet SET cost = ST_Length(geom);
UPDATE roadnet SET reverse_cost = ST_Length(geom);

select pgr_createTopology('roadnet', 0.0001,'geom','id');

select st_srid(the_geom)
from roadnet_vertices_pgr

select pgr_dijkstra('SELECT * FROM roadnet', 1, 41,FALSE)
SELECT edge

FROM pgr_dijkstra(
    'SELECT id, source, target, cost, reverse_cost FROM roadnet',
    1,  -- 起点 ID
    41, -- 终点 ID
    false
) WHERE edge != -1;

SELECT ST_Union(geom) AS path_geom
FROM roadnet
WHERE id IN (300015, 300033, 300058, 300075, 300117, 300132, 300138, 300158, 300163);

WITH dijkstra_path AS (
    SELECT edge
    FROM pgr_dijkstra(
        'SELECT gid AS id, source, target, cost, reverse_cost FROM roadnet',
        1,  -- 起点 ID
        41, -- 终点 ID
        false
    ) WHERE edge != -1
)
SELECT ST_Union(geom) AS path_geom
FROM roadnet
WHERE gid IN (SELECT edge FROM dijkstra_path);
