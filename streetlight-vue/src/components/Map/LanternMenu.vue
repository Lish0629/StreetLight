<template>
  <div class="lantern-menu">
    <el-table :data="tableData" style="width: 100%" height="100%" :header-cell-style="{ position: 'sticky', top: 0, zIndex: 1 }">
      <el-table-column prop="id" label="序号" width="120"></el-table-column>
        <el-table-column label="路灯状态" width="180"
        :filters="statusFilters"
        :filter-method="filterStatus"
        column-key="status"
        >
        <template #default="{ row }">
          <el-select
            v-model="row.status"
            placeholder="请选择状态"
            @change="updateStatus(row)"
          >
            <el-option label="正常" :value="true" />
            <el-option label="异常" :value="false" />
          </el-select>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script setup>
import { ref,onMounted } from 'vue';
import { ElTable, ElTableColumn } from 'element-plus';
import axios from 'axios';

const statusFilters = [
  { text: "正常", value: true },
  { text: "异常", value: false },
];
const filterStatus = (value, row) => row.status === value;

const tableData = ref([]);

const fetchData = async () => {
  try{
    const response = await axios.get('http://localhost:5000/lantern');
    tableData.value = response.data;
    console.log(tableData.value);
  } catch (error) {
    console.log(error);
  }
};

// 更新路灯状态
const updateStatus = async (row) => {
  try {
    const response = await axios.put(`http://localhost:5000/lantern/${row.id}`, {
      status: row.status,
    });
    console.log("状态更新成功:", response.data);
  } catch (error) {
    console.error("状态更新失败:", error);
  }
};

onMounted(() => {
  fetchData();
  });
</script>

<style scoped>
.lantern-menu {
  position: absolute;
  top: 0;
  right: 0;
  width: 300px; /* 固定宽度 */
  height: 100%; /* 填满父容器 */
  background-color: rgba(0, 0, 0, 0.3); /* 半透明背景 */
  color: white;
  overflow-y: auto; /* 垂直滚动 */
  box-shadow: -2px 0 5px rgba(0, 0, 0, 0.5); /* 右侧阴影效果 */
}
</style>