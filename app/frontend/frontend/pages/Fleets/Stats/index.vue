<template>
  <section class="container stats">
    <div v-if="fleet" class="row">
      <div class="col-12">
        <div class="row">
          <div class="col-12">
            <BreadCrumbs :crumbs="crumbs" />
            <h1>
              {{ $t("headlines.fleets.stats") }}
            </h1>
          </div>
        </div>
        <div class="row">
          <div class="col-12 col-sm-6 col-lg-3">
            <Panel variant="primary">
              <div class="panel-box">
                <div class="panel-box-icon">
                  <i class="fad fa-user fa-4x" />
                </div>
                <div class="panel-box-text">
                  {{ totalMemberCount }}
                  <div class="panel-box-text-info">
                    {{ $t("labels.stats.quickStats.totalMembers") }}
                  </div>
                </div>
              </div>
            </Panel>
          </div>
          <div class="col-12 col-sm-6 col-lg-3">
            <Panel variant="primary">
              <div class="panel-box">
                <div class="panel-box-icon">
                  <i class="fad fa-rocket fa-4x" />
                </div>
                <div class="panel-box-text">
                  {{ totalShipCount }}
                  <div class="panel-box-text-info">
                    {{ $t("labels.stats.quickStats.totalShips") }}
                  </div>
                </div>
              </div>
            </Panel>
          </div>
          <div class="col-12 col-sm-6 col-lg-3">
            <Panel variant="primary">
              <div class="panel-box">
                <div class="panel-box-icon">
                  <i class="fad fa-user fa-4x" />
                </div>
                <div class="panel-box-text">
                  {{ minCrew }}
                  <div class="panel-box-text-info">
                    {{ $t("labels.hangarMetrics.totalMinCrew") }}
                  </div>
                </div>
              </div>
            </Panel>
          </div>
          <div class="col-12 col-sm-6 col-lg-3">
            <Panel variant="primary">
              <div class="panel-box">
                <div class="panel-box-icon">
                  <i class="fad fa-users fa-4x" />
                </div>
                <div class="panel-box-text">
                  {{ maxCrew }}
                  <div class="panel-box-text-info">
                    {{ $t("labels.hangarMetrics.totalMaxCrew") }}
                  </div>
                </div>
              </div>
            </Panel>
          </div>
          <div class="col-12 col-sm-6 col-lg-3">
            <Panel variant="primary">
              <div class="panel-box">
                <div class="panel-box-icon">
                  <i class="fad fa-box-open fa-4x" />
                </div>
                <div class="panel-box-text">
                  {{ totalCargo }}
                  <div class="panel-box-text-info">
                    {{ $t("labels.hangarMetrics.totalCargo") }}
                  </div>
                </div>
              </div>
            </Panel>
          </div>
        </div>
        <div class="row">
          <div class="col-12 col-md-6">
            <Panel>
              <div class="panel-heading">
                <h2 class="panel-title">
                  {{ $t("labels.stats.modelsByClassification") }}
                </h2>
              </div>
              <Chart
                key="models-by-classification"
                :load-data="loadModelsByClassification"
                tooltip-type="ship-pie"
                type="pie"
              />
            </Panel>
          </div>
          <div class="col-12 col-md-6">
            <Panel>
              <div class="panel-heading">
                <h2 class="panel-title">
                  {{ $t("labels.stats.modelsBySize") }}
                </h2>
              </div>
              <Chart
                key="models-by-size"
                :load-data="loadModelsBySize"
                tooltip-type="ship-pie"
                type="pie"
              />
            </Panel>
          </div>
        </div>
        <div class="row">
          <div class="col-12 col-md-5">
            <Panel>
              <div class="panel-heading">
                <h2 class="panel-title">
                  {{ $t("labels.stats.modelsByProductionStatus") }}
                </h2>
              </div>
              <Chart
                key="models-by-production-status"
                :load-data="loadModelsByProductionStatus"
                tooltip-type="ship-pie"
                type="pie"
              />
            </Panel>
          </div>
          <div class="col-12 col-md-7">
            <Panel>
              <div class="panel-heading">
                <h2 class="panel-title">
                  {{ $t("labels.stats.modelsByManufacturer") }}
                </h2>
              </div>
              <Chart
                key="models-by-manufacturer"
                :load-data="loadModelsByManufacturer"
                tooltip-type="ship-pie"
                type="pie"
              />
            </Panel>
          </div>
        </div>
        <div class="row">
          <div class="col-12 col-md-6">
            <Panel>
              <div class="panel-heading">
                <h2 class="panel-title">
                  {{
                    $t("labels.stats.vehiclesByModel", {
                      limit: vehiclesByModelLimit,
                    })
                  }}
                </h2>
              </div>
              <Chart
                key="vehicles-by-model"
                :load-data="loadVehiclesByModel"
                tooltip-type="ship"
                type="bar"
              />
            </Panel>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import Chart from "@/frontend/core/components/Chart/index.vue";
import Panel from "@/frontend/core/components/Panel/index.vue";
import { fleetRouteGuard } from "@/frontend/utils/RouteGuards/Fleets";
import fleetsCollection from "@/frontend/api/collections/Fleets";
import vehiclesCollection from "@/frontend/api/collections/FleetVehicles";
import membersCollection from "@/frontend/api/collections/FleetMembers";
import BreadCrumbs from "@/frontend/core/components/BreadCrumbs/index.vue";

@Component({
  beforeRouteEnter: fleetRouteGuard,
  components: {
    Chart,
    Panel,
    BreadCrumbs,
  },
})
export default class FleetStats extends Vue {
  collection: FleetsCollection = fleetsCollection;

  vehiclesCollection: FleetVehiclesCollection = vehiclesCollection;

  membersCollection: FleetMembersCollection = membersCollection;

  vehiclesByModelLimit = 20;

  get fleet() {
    return this.collection.record;
  }

  get slug() {
    return this.$route.params.slug;
  }

  get vehicleStats() {
    return this.vehiclesCollection.stats;
  }

  get memberStats() {
    return this.membersCollection.stats;
  }

  get totalMemberCount() {
    if (!this.memberStats) {
      return 0;
    }

    return this.memberStats.total;
  }

  get totalShipCount() {
    if (!this.vehicleStats) {
      return 0;
    }

    return this.vehicleStats.total;
  }

  get minCrew() {
    if (!this.vehicleStats) {
      return this.$toNumber(0, "people");
    }

    return this.$toNumber(this.vehicleStats.metrics.totalMinCrew, "people");
  }

  get maxCrew() {
    if (!this.vehicleStats) {
      return this.$toNumber(0, "people");
    }

    return this.$toNumber(this.vehicleStats.metrics.totalMaxCrew, "people");
  }

  get totalCargo() {
    if (!this.vehicleStats) {
      return this.$toNumber(0, "cargo");
    }

    return this.$toNumber(this.vehicleStats.metrics.totalCargo, "cargo");
  }

  get crumbs() {
    if (!this.fleet) {
      return [];
    }

    return [
      {
        to: {
          name: "fleet",
          params: {
            slug: this.fleet.slug,
          },
        },
        label: this.fleet.name,
      },
    ];
  }

  get metaTitle() {
    if (!this.fleet) {
      return null;
    }

    return this.$t("title.fleets.stats", { fleet: this.fleet.name });
  }

  mounted() {
    this.fetchFleet();
    this.loadQuickStats();
  }

  loadQuickStats() {
    this.vehiclesCollection.findStats({ slug: this.slug });
    this.membersCollection.findStats({ slug: this.slug });
  }

  loadModelsByClassification() {
    return this.collection.findModelsByClassificationBySlug(this.slug);
  }

  loadVehiclesByModel() {
    return this.collection.findVehiclesByModelBySlug(
      this.slug,
      this.vehiclesByModelLimit,
    );
  }

  loadModelsBySize() {
    return this.collection.findModelsBySizeBySlug(this.slug);
  }

  loadModelsByManufacturer() {
    return this.collection.findModelsByManufacturerBySlug(this.slug);
  }

  loadModelsByProductionStatus() {
    return this.collection.findModelsByProductionStatusBySlug(this.slug);
  }

  async fetchFleet() {
    await this.collection.findBySlug(this.$route.params.slug);
  }
}
</script>
