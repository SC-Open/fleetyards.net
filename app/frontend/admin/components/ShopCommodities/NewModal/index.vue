<template>
  <ValidationObserver v-slot="{ handleSubmit }" :small="true" :slim="true">
    <Modal v-if="form" :title="title">
      <form :id="formId" @submit.prevent="handleSubmit(submit)">
        <div class="row">
          <div class="col-12 col-md-6">
            <div class="form-group">
              <ValidationProvider
                v-slot="{ errors }"
                vid="commodityItemType"
                rules="required"
                :name="$t('labels.shopCommodity.commodityItemType')"
                :slim="true"
              >
                <FilterGroup
                  v-model="form.commodityItemType"
                  :options="commodityTypeOptions"
                  :error="errors[0]"
                  name="commodityItemType"
                  :no-label="true"
                />
              </ValidationProvider>
            </div>
          </div>
          <div class="col-12 col-md-6">
            <div class="form-group">
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'Component'"
                key="component-item-type-filters-filter-group"
                v-model="componentItemTypeFilter"
                :label="
                  $t('labels.filters.shopCommodities.componentItemTypeFilter')
                "
                :collection="componentItemTypeFiltersCollection"
                name="component-item-type-filter"
                :searchable="true"
                :no-label="true"
              />
              <template v-if="form.commodityItemType === 'Equipment'">
                <CollectionFilterGroup
                  key="equipment-type-filters-filter-group"
                  v-model="equipmentTypeFilter"
                  :label="
                    $t('labels.filters.shopCommodities.equipmentTypeFilter')
                  "
                  :collection="equipmentTypeFiltersCollection"
                  name="equipment-type-filter"
                  :searchable="true"
                  :no-label="true"
                />

                <CollectionFilterGroup
                  key="equipment-slot-filters-filter-group"
                  v-model="equipmentSlotFilter"
                  :label="
                    $t('labels.filters.shopCommodities.equipmentSlotFilter')
                  "
                  :collection="equipmentSlotFiltersCollection"
                  name="equipment-slot-filter"
                  :searchable="true"
                  :no-label="true"
                />
              </template>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'Commodity'"
                key="commodity-filter-group"
                :label="$t('labels.filters.shopCommodities.commodity')"
                :collection="commoditiesCollection"
                name="commodity-commodityItemId"
                value-attr="id"
                :paginated="true"
                :searchable="true"
                :no-label="true"
                :return-object="true"
                @input="add"
              />
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'Component'"
                key="component-filter-group"
                :label="$t('labels.filters.shopCommodities.component')"
                :collection="componentsCollection"
                :collection-filter="{
                  itemTypeEq: componentItemTypeFilter,
                }"
                name="components-commodityItemId"
                value-attr="id"
                :paginated="true"
                :searchable="true"
                :no-label="true"
                :return-object="true"
                @input="add"
              />
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'Equipment'"
                key="equipment-filter-group"
                :label="$t('labels.filters.shopCommodities.equipment')"
                :collection="equipmentCollection"
                :collection-filter="{
                  equipmentTypeEq: equipmentTypeFilter,
                  slotEq: equipmentSlotFilter,
                }"
                name="equipment-commodityItemId"
                value-attr="id"
                :return-object="true"
                :paginated="true"
                :searchable="true"
                :no-label="true"
                @input="add"
              />
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'Model'"
                key="model-filter-group"
                :label="$t('labels.filters.shopCommodities.model')"
                :collection="modelsCollection"
                name="models-commodityItemId"
                value-attr="id"
                :paginated="true"
                :searchable="true"
                :no-label="true"
                :return-object="true"
                @input="add"
              />
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'ModelModule'"
                key="model-module-filter-group"
                :label="$t('labels.filters.shopCommodities.modelModule')"
                :collection="modelModulesCollection"
                name="modelModules-commodityItemId"
                value-attr="id"
                :paginated="true"
                :searchable="true"
                :no-label="true"
                :return-object="true"
                @input="add"
              />
              <CollectionFilterGroup
                v-if="form.commodityItemType === 'ModelPaint'"
                key="model-paint-filter-group"
                :label="$t('labels.filters.shopCommodities.modelPaint')"
                :collection="modelPaintsCollection"
                name="modelPaints-commodityItemId"
                value-attr="id"
                label-attr="nameWithModel"
                :paginated="true"
                :searchable="true"
                :no-label="true"
                :return-object="true"
                @input="add"
              />
            </div>
          </div>
        </div>
      </form>
      <div v-for="(item, index) in items" :key="index" class="row">
        <div class="col-8 col-md-10">
          <TeaserPanel :item="item" variant="text" :with-description="false" />
        </div>
        <div class="col-4 col-md-2">
          <Btn
            v-tooltip="$t('actions.remove')"
            :aria-label="$t('actions.remove')"
            @click.native="removeItem(index)"
          >
            <i class="fa fa-trash" />
          </Btn>
        </div>
      </div>

      <template #footer>
        <div class="float-sm-right">
          <Btn
            :form="formId"
            :loading="submitting"
            type="submit"
            size="large"
            data-test="shopCommodity-save"
            :inline="true"
          >
            {{ $t("actions.save") }}
          </Btn>
        </div>
      </template>
    </Modal>
  </ValidationObserver>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import Btn from "@/frontend/core/components/Btn/index.vue";
import shopCommodityCollection from "@/admin/api/collections/ShopCommodities";
import modelsCollection from "@/admin/api/collections/Models";
import commoditiesCollection from "@/admin/api/collections/Commodities";
import componentsCollection from "@/admin/api/collections/Components";
import equipmentCollection from "@/admin/api/collections/Equipment";
import modelModulesCollection from "@/admin/api/collections/ModelModules";
import modelPaintsCollection from "@/admin/api/collections/ModelPaints";
import componentItemTypeFiltersCollection from "@/admin/api/collections/ComponentItemTypeFilters";
import equipmentTypeFiltersCollection from "@/admin/api/collections/EquipmentTypeFilters";
import equipmentSlotFiltersCollection from "@/admin/api/collections/EquipmentSlotFilters";
import CollectionFilterGroup from "@/frontend/core/components/Form/CollectionFilterGroup/index.vue";
import FilterGroup from "@/frontend/core/components/Form/FilterGroup/index.vue";
import Modal from "@/frontend/core/components/AppModal/Inner/index.vue";
import TeaserPanel from "@/frontend/core/components/TeaserPanel/index.vue";

// TODO: move to collection model or use openapi schema types when available
type ShopCommoditiesFormData = {
  commodityItemType: string;
  commodityItemId?: string;
};

@Component<VehicleModal>({
  components: {
    Modal,
    FilterGroup,
    CollectionFilterGroup,
    Btn,
    TeaserPanel,
  },
})
export default class VehicleModal extends Vue {
  @Prop({ required: true }) shopId: string;

  @Prop({ default: null }) commodityItemType: string | null;

  @Prop({ default: null }) itemTypeFilter: string | null;

  modelsCollection: ModelsCollection = modelsCollection;

  commoditiesCollection: CommoditiesCollection = commoditiesCollection;

  componentsCollection: ComponentsCollection = componentsCollection;

  equipmentCollection: EquipmentCollection = equipmentCollection;

  modelModulesCollection: ModelModulesCollection = modelModulesCollection;

  modelPaintsCollection: ModelPaintsCollection = modelPaintsCollection;

  componentItemTypeFiltersCollection: ComponentItemTypeFiltersCollection =
    componentItemTypeFiltersCollection;

  equipmentTypeFiltersCollection: EquipmentTypeFiltersCollection =
    equipmentTypeFiltersCollection;

  equipmentSlotFiltersCollection: EquipmentSlotFiltersCollection =
    equipmentSlotFiltersCollection;

  submitting = false;

  componentItemTypeFilter: string | null = null;

  equipmentTypeFilter: string | null = null;

  equipmentSlotFilter: string | null = null;

  form: ShopCommoditiesFormData | null = null;

  items = [];

  commodityTypeOptions: FilterGroupItem[] = [
    {
      value: "Commodity",
      name: "Commodity",
    },
    {
      value: "Component",
      name: "Component",
    },
    {
      value: "Equipment",
      name: "Equipment",
    },
    {
      value: "Model",
      name: "Model",
    },
    {
      value: "ModelModule",
      name: "Model Module",
    },
    {
      value: "ModelPaint",
      name: "Model Paint",
    },
  ];

  get formId() {
    return "shopCommodity-new";
  }

  get title() {
    return this.$t("headlines.modals.shopCommodity.create");
  }

  mounted() {
    this.componentItemTypeFilter = this.itemTypeFilter;

    this.setupForm();
  }

  fetchSubCategories() {
    return this.$api.get("filters/shop-commodities/sub-categories");
  }

  setupForm() {
    this.form = {
      commodityItemType: this.commodityItemType,
    };
  }

  async submit() {
    this.submitting = true;

    await Promise.all(
      this.items.map(async (item) => {
        await shopCommodityCollection.create(this.shopId, {
          commodityItemId: item.id,
          ...this.form,
        });
      }),
    );

    this.$comlink.$emit("commodities-update");

    this.$comlink.$emit("close-modal");

    this.submitting = false;
  }

  add(value) {
    this.items.push(value);
  }

  removeItem(index) {
    this.items.splice(index, 1);
  }
}
</script>
