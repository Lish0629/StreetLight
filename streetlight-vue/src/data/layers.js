import TileLayer from 'ol/layer/Tile.js';
import ImageLayer from "ol/layer/Image.js";
import { ImageWMS,OSM,XYZ, } from "ol/source";
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import GeoJSON from 'ol/format/GeoJSON';
import { Style, Fill, Stroke, Circle as CircleStyle } from 'ol/style';
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
  className:'blacktile'
});

//天地图标注底图
export const markLayer = new TileLayer({
  title: '天地图标注图层',
  source: new XYZ({
    url: 'http://t4.tianditu.com/DataServer?T=cva_w&tk=9aa49772a6d157afe863294b50b104a3&x={x}&y={y}&l={z}'
  }),
  className:'blackmark'
});

//OSM底图
export const osmLayer = new TileLayer({
  title:'OpenStreet',
  source: new OSM()
});

//路灯WMS图层
export const geomap = new ImageLayer({
  visible: true,
  opacity: 0.5,
  source: new ImageWMS({
    url: 'http://localhost:8081/geoserver/streetlight/wms',
    params: {'LAYERS': 'streetlight:lantern'},
    ratio: 1,
    serverType: 'geoserver',
  })
});

//路灯矢量
export const lantern = new VectorLayer({
  visible: true,
  source: new VectorSource({
    format: new GeoJSON({
      dataProjection: "EPSG:4490",  // 数据的原始坐标系为 EPSG:4490
      featureProjection: "EPSG:3857",  // 转换为地图显示坐标系 EPSG:3857
    }),
    url: 'http://localhost:8081/geoserver/streetlight/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=streetlight:lantern&outputFormat=application/json',
  }),
  style: (feature) => {
    const isTrue = feature.get('status'); // 假设 'status' 是属性名
    return new Style({
      image: new CircleStyle({
        radius: 6,
        fill: new Fill({
          color: isTrue ? 'rgba(255, 255, 0, 0.4)' : 'rgba(255, 0, 0, 0.4)', // 'true' 为黄色，'false' 为红色
        }),
        stroke: new Stroke({
          color: 'black', // 外围黑色边框
          width: 1,
        }),
      }),
    });
  },
});


// 创建图层样式函数
const getStyleFunction = (showAll) => {
  return (feature) => {
    const isTrue = feature.get('status'); // 假设 'status' 是属性名
    // 只有在 showAll 为 true 或者 status 为 false 时才显示
    if (showAll || !isTrue) {
      return new Style({
        image: new CircleStyle({
          radius: 6,
          fill: new Fill({
            color: isTrue ? 'rgba(255, 255, 0, 0.4)' : 'rgba(255, 0, 0, 0.4)', // 'true' 为黄色，'false' 为红色
          }),
          stroke: new Stroke({
            color: 'black', // 外围黑色边框
            width: 1,
          }),
        }),
      });
    }
    return null; // 不显示 status 为 true 的要素
  };
};

let lanternLayer = null; // 存储图层对象
export const createLanternLayer = (showAll) => {
  if (lanternLayer) {
    lanternLayer.setStyle(getStyleFunction(showAll)); // 更新样式
    return lanternLayer;
  }

  lanternLayer = new VectorLayer({
    visible: true,
    source: new VectorSource({
      format: new GeoJSON({
        dataProjection: "EPSG:4490",
        featureProjection: "EPSG:3857",
      }),
      url: 'http://localhost:8081/geoserver/streetlight/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=streetlight:lantern&outputFormat=application/json',
    }),
    style: getStyleFunction(showAll), // 初始样式
  });

  return lanternLayer;
};