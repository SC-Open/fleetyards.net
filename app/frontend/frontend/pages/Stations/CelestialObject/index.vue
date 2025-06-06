<template>
  <section class="container">
    <div class="row">
      <div class="col-12">
        <BreadCrumbs :crumbs="crumbs" />
        <h1 v-if="celestialObject">
          {{ celestialObject.name }}
          <small class="text-muted">{{ celestialObject.designation }}</small>
        </h1>
      </div>
    </div>
    <div v-if="celestialObject" class="row">
      <div class="col-12 col-lg-8">
        <blockquote v-if="celestialObject.description" class="description">
          <p v-html="celestialObject.description" />
        </blockquote>
      </div>
      <div class="col-12 col-lg-4">
        <Panel>
          <CelestialObjectMetrics :celestial-object="celestialObject" padding />
        </Panel>
      </div>
    </div>
    <div class="row">
      <div
        v-if="celestialObject && celestialObject.moons?.length"
        class="col-12"
      >
        <h2>{{ $t("headlines.moons") }}</h2>
        <transition-group name="fade-list" class="row" tag="div" appear>
          <div
            v-for="moon in celestialObject.moons"
            :key="moon.slug"
            class="col-12 col-md-6 col-lg-3 fade-list-item"
          >
            <ItemPanel
              :item="moon"
              :route="{
                name: 'celestial-object',
                params: {
                  starsystem: celestialObject.starsystem.slug,
                  slug: moon.slug,
                },
              }"
            />
          </div>
        </transition-group>
      </div>
    </div>
    <div v-if="celestialObject && stations.length" class="row">
      <div class="col-12 col-lg-6">
        <h2>{{ $t("headlines.stations") }}</h2>
      </div>
      <div class="col-12 col-lg-6">
        <Paginator
          v-if="stations.length"
          :page="currentPage"
          :total="totalPages"
          right
        />
      </div>
      <div class="col-12">
        <transition-group name="fade-list" class="row" tag="div" appear>
          <div
            v-for="station in stations"
            :key="station.slug"
            class="col-12 fade-list-item"
          >
            <StationPanel :station="station" />
          </div>
        </transition-group>
        <Loader :loading="loading" :fixed="true" />
      </div>
      <div class="col-12">
        <Paginator
          v-if="stations.length"
          :page="currentPage"
          :total="totalPages"
          right
        />
      </div>
    </div>
  </section>
</template>

<script>
import Loader from "@/frontend/core/components/Loader/index.vue";
import Panel from "@/frontend/core/components/Panel/index.vue";
import { scrollToAnchor } from "@/frontend/utils/scrolling";
import Pagination from "@/frontend/mixins/Pagination";
import StationPanel from "@/frontend/components/Stations/Panel/index.vue";
import ItemPanel from "@/frontend/components/Stations/Item/index.vue";
import BreadCrumbs from "@/frontend/core/components/BreadCrumbs/index.vue";
import CelestialObjectMetrics from "@/frontend/components/CelestialObjects/Metrics/index.vue";

export default {
  name: "CelestialObjectDetail",

  components: {
    Loader,
    Panel,
    StationPanel,
    ItemPanel,
    CelestialObjectMetrics,
    BreadCrumbs,
  },

  mixins: [Pagination],

  data() {
    return {
      loading: false,
      celestialObject: null,
      stations: [],
    };
  },

  computed: {
    metaTitle() {
      if (!this.celestialObject) {
        return null;
      }

      return this.$t("title.celestialObject", {
        celestialObject: this.celestialObject.name,
        starsystem: this.celestialObject.starsystem.name,
      });
    },

    crumbs() {
      if (!this.celestialObject) {
        return null;
      }

      const crumbs = [
        {
          to: {
            name: "starsystems",
            hash: `#${this.celestialObject.starsystem.slug}`,
          },
          label: this.$t("nav.starsystems"),
        },
        {
          to: {
            name: "starsystem",
            params: {
              slug: this.celestialObject.starsystem.slug,
            },
            hash: `#${this.celestialObject.slug}`,
          },
          label: this.celestialObject.starsystem.name,
        },
      ];

      if (this.celestialObject.parent) {
        crumbs.push({
          to: {
            name: "celestial-object",
            params: {
              starsystem: this.celestialObject.starsystem.slug,
              slug: this.celestialObject.parent.slug,
            },
          },
          label: this.celestialObject.parent.name,
        });
      }

      return crumbs;
    },
  },

  watch: {
    $route() {
      this.fetch();
    },
  },

  created() {
    this.fetch();
  },

  methods: {
    async fetch() {
      this.loading = true;
      const response = await this.$api.get(
        `celestial-objects/${this.$route.params.slug}`,
      );
      this.loading = false;
      if (!response.error) {
        this.celestialObject = response.data;
        this.fetchStations();
      }
    },

    async fetchStations() {
      this.loading = true;
      const response = await this.$api.get("stations", {
        q: {
          ...this.$route.query.q,
          celestialObjectEq: this.$route.params.slug,
          sorts: ["station_type asc", "name asc"],
        },
        page: this.$route.query.page,
      });

      this.loading = false;
      if (!response.error) {
        this.stations = response.data;

        this.$nextTick(() => {
          scrollToAnchor(this.$route.hash);
        });
      }

      this.setPages(response.meta);
    },
  },
};
</script>

<style lang="scss" scoped>
@import "index";
</style>
