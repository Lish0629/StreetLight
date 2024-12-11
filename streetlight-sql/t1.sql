WITH 
dijkstra_path AS (
    SELECT edge, cost
    FROM pgr_dijkstra(
        'SELECT id, source, target, cost, reverse_cost FROM roadnet',
        42,  -- 起点节点 ID
        10,  -- 终点节点 ID
        false -- 不考虑有向图
    )
    WHERE edge != -1
),
path_geom AS (
    SELECT 
        ST_Union(geom) AS pgeom,  -- 聚合路径几何
        SUM(cost) AS total_cost  -- 计算总成本
    FROM roadnet
    WHERE id IN (SELECT edge FROM dijkstra_path)
)
-- 查询合并后的路径和总成本
SELECT * FROM dijkstra_path;

SELECT pgr_dijkstra(
        'SELECT id, source, target, cost, reverse_cost FROM roadnet',
        42,  -- 起点节点 ID
        10,  -- 终点节点 ID
        false -- 不考虑有向图
    )