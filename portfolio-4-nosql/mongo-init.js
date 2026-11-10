db = db.getSiblingDB("nexacart_catalogue");
db.products.drop();

db.createCollection("products", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["productId", "name", "slug", "brand", "category", "active", "variants"],
      properties: {
        productId: { bsonType: "string" },
        name: { bsonType: "string", minLength: 1 },
        slug: { bsonType: "string", minLength: 1 },
        brand: { bsonType: "string" },
        category: {
          bsonType: "object",
          required: ["slug", "name"],
          properties: { slug: { bsonType: "string" }, name: { bsonType: "string" } }
        },
        active: { bsonType: "bool" },
        attributes: { bsonType: "object" },
        variants: {
          bsonType: "array",
          minItems: 1,
          items: {
            bsonType: "object",
            required: ["sku", "name", "price"],
            properties: {
              sku: { bsonType: "string" },
              name: { bsonType: "string" },
              price: { bsonType: "decimal", minimum: NumberDecimal("0") }
            }
          }
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});

db.products.insertMany([
  {
    productId: "20000000-0000-0000-0000-000000000001",
    name: "Wireless Headphones",
    slug: "wireless-headphones",
    brand: "Northstar",
    category: { slug: "electronics", name: "Electronics" },
    active: true,
    attributes: { wireless: true, batteryHours: 30, noiseCancellation: true },
    media: [{ type: "image", url: "https://example.test/products/headphones-black.png" }],
    variants: [
      { sku: "NS-HEAD-BLK", name: "Black", price: NumberDecimal("89.99") },
      { sku: "NS-HEAD-WHT", name: "White", price: NumberDecimal("89.99") }
    ],
    ratingSummary: { average: 4.5, count: 128 }
  },
  {
    productId: "20000000-0000-0000-0000-000000000002",
    name: "Smart Fitness Watch",
    slug: "smart-fitness-watch",
    brand: "Pace",
    category: { slug: "fitness", name: "Fitness" },
    active: true,
    attributes: { waterResistant: true, gps: true, displaySizeMm: 40 },
    variants: [{ sku: "PACE-WATCH-40", name: "40 mm", price: NumberDecimal("129.50") }],
    ratingSummary: { average: 4.2, count: 64 }
  }
]);

db.products.createIndex({ slug: 1 }, { unique: true });
db.products.createIndex({ "variants.sku": 1 }, { unique: true });
db.products.createIndex({ "category.slug": 1, active: 1, name: 1 });
db.products.createIndex({ name: "text", brand: "text", "category.name": "text" });
db.products.createIndex({ attributes: 1 });

printjson(db.products.getIndexes());
