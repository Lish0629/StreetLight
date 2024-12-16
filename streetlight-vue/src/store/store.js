import { defineStore } from "pinia";

export const useMapCooStore = defineStore('',()=>{
  const points = {
    point1:{},
    point2:{}
  };

  function setPoint(pointIndex,coordinates){
    points[pointIndex]=coordinates;
  };

  return {points,setPoint}
})