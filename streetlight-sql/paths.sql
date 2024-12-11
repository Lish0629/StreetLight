CREATE TABLE paths (
    id SERIAL PRIMARY KEY,                 -- 路径唯一标识
    start_point GEOMETRY(Point, 3857),     -- 起点坐标
    end_point GEOMETRY(Point,3857),       -- 终点坐标
    start_node INTEGER,                    -- 起点节点ID
    end_node INTEGER,                      -- 终点节点ID
    path GEOMETRY(MultiLineString, 3857),       -- 路径几何信息
    total_cost DOUBLE PRECISION,           -- 路径总权重
    created_at TIMESTAMP DEFAULT now()     -- 创建时间
);
