<template>
  <FilteredList
    :collection="collection"
    collection-method="findAllForGallery"
    :name="$route.name"
    :route-query="$route.query"
    :hash="$route.hash"
    :params="routeParams"
    :paginated="true"
    class="images"
  >
    <template #default="{ records, loading }">
      <ImageUploader
        :loading="loading"
        :images="records"
        :gallery-id="galleryId"
        gallery-type="Model"
        @image-deleted="fetch"
        @image-uploaded="fetch"
      />
    </template>
  </FilteredList>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import ImageUploader from "@/admin/components/ImageUploader/index.vue";
import FilteredList from "@/frontend/core/components/FilteredList/index.vue";
import imagesCollection, {
  AdminImagesCollection,
} from "@/admin/api/collections/Images";

@Component<AdminModelImages>({
  components: {
    ImageUploader,
    FilteredList,
  },
})
export default class AdminModelImages extends Vue {
  collection: AdminImagesCollection = imagesCollection;

  get galleryId() {
    return this.$route.params.uuid;
  }

  get routeParams() {
    return {
      galleryType: "Model",
      galleryId: this.galleryId,
    };
  }

  get filters() {
    return {
      ...this.routeParams,
      page: this.$route.query.page,
    };
  }

  async fetch() {
    await this.collection.findAllForGallery(this.filters);
  }
}
</script>
