import { defineStore } from "pinia";
import { reactive,ref } from "vue";
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
  const selectPointid = ref(0);
  function handleSelect (index){
    selectPointid.value=index;
  };

  return {selectPoint,selectPointid,handleSelect}
})