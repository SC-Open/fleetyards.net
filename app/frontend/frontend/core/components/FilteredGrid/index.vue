<template>
  <transition-group name="fade-list" class="row" tag="div" :appear="true">
    <div
      v-for="(record, index) in records"
      :key="record[primaryKey]"
      :class="{
        'col-xxl-3 col-3xl-2dot4': filterVisible,
        'col-xl-3 col-xxl-2dot4 col-3xl-2': !filterVisible,
      }"
      class="col-12 col-md-6 col-lg-4 fade-list-item"
    >
      <slot :record="record" :index="index" />
    </div>
  </transition-group>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component<FilteredGrid>({})
export default class FilteredGrid extends Vue {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  @Prop({ required: true }) records!: any[];

  @Prop({ required: true }) primaryKey!: string;

  @Prop({ required: true }) filterVisible!: boolean;
}
</script>
