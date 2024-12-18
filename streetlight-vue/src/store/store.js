import { defineStore } from "pinia";
import { reactive } from "vue";
export const useMapCooStore = defineStore('MapCoo',()=>{
  const points = {
    point1:{},
    point2:{}
  };

  function setPoint(pointIndex,coordinates){
    points[pointIndex]=coordinates;
  };

  return {points,setPoint}
});

export const useSelectStore = defineStore('SelectPoint',()=>{
  const selectPoint = reactive({});
  return {selectPoint}
})

export const createPointStore = defineStore('CreatePoint',()=>{
  const drawPointStatus = ref(false);
  function handleCreateDraw(){
    drawPointStatus.value=!drawPointStatus.value
  };

  return {drawPointStatus,handleCreateDraw}
})