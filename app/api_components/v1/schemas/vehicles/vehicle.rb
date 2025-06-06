# frozen_string_literal: true

module V1
  module Schemas
    module Vehicles
      class Vehicle
        include SchemaConcern

        schema({
          type: :object,
          properties: {
            id: {type: :string, format: :uuid},
            name: {type: :string},
            slug: {type: :string},
            serial: {type: :string},
            alternativeNames: {type: :array, items: {type: :string}},
            boughtVia: {"$ref": "#/components/schemas/BoughtViaEnum"},
            boughtViaLabel: {type: :string},
            flagship: {type: :boolean},
            hangarGroupIds: {type: :array, items: {type: :string, format: :uuid}},
            hangarGroups: {type: :array, items: {"$ref": "#/components/schemas/HangarGroup"}},
            loaner: {type: :boolean},
            model: {"$ref": "#/components/schemas/Model"},
            modelModuleIds: {type: :array, items: {type: :string, format: :uuid}},
            modelUpgradeIds: {type: :array, items: {type: :string, format: :uuid}},
            modulePackage: {"$ref": "#/components/schemas/ModelModulePackage"},
            nameVisible: {type: :boolean},
            paint: {"$ref": "#/components/schemas/ModelPaint"},
            public: {type: :boolean},
            saleNotify: {type: :boolean},
            upgrade: {"$ref": "#/components/schemas/ModelUpgrade"},
            wanted: {type: :boolean},
            createdAt: {type: :string, format: "date-time"},
            updatedAt: {type: :string, format: "date-time"}
          },
          additionalProperties: false,
          required: %w[
            id model wanted boughtVia loaner flagship public nameVisible saleNotify alternativeNames
            modelUpgradeIds hangarGroupIds hangarGroups modelModuleIds createdAt updatedAt
          ]
        })
      end
    end
  end
end
