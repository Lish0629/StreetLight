import TileLayer from 'ol/layer/Tile.js';
import ImageLayer from "ol/layer/Image.js";
import { fromLonLat } from 'ol/proj';
import { ImageWMS,OSM,XYZ } from "ol/source";

//天地图影像底图
export const imgLayer = new TileLayer({
  title: '天地图影像底图',
  source: new XYZ({
    url: 'http://t4.tianditu.com/DataServer?T=img_w&tk=9aa49772a6d157afe863294b50b104a3&x={x}&y={y}&l={z}'
  }),
});

//天地图矢量底图
export const tileLayer = new TileLayer({
  title: '天地图矢量底图',
  source: new XYZ({
    url: 'http://t4.tianditu.com/DataServer?T=vec_w&tk=9aa49772a6d157afe863294b50b104a3&x={x}&y={y}&l={z}'
  }),
  className:'blackbase'
});

//天地图标注底图
export const markLayer = new TileLayer({
  title: '天地图标注图层',
  source: new XYZ({
    url: 'http://t4.tianditu.com/DataServer?T=cva_w&tk=9aa49772a6d157afe863294b50b104a3&x={x}&y={y}&l={z}'
  }),
  className:'blackbase'
});

//OSM底图
export const osmLayer = new TileLayer({
  title:'OpenStreet',
  source: new OSM()
});