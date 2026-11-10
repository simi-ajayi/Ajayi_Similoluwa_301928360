db = db.getSiblingDB("nexacart_catalogue");

print("Active electronics:");
db.products.find(
  { "category.slug": "electronics", active: true },
  { name: 1, brand: 1, "variants.sku": 1, "variants.price": 1 }
).sort({ name: 1 }).forEach(printjson);

print("Products with GPS:");
db.products.find({ "attributes.gps": true }, { name: 1, attributes: 1 }).forEach(printjson);

print("Text search:");
db.products.find({ $text: { $search: "wireless headphones" } }, { score: { $meta: "textScore" }, name: 1 })
  .sort({ score: { $meta: "textScore" } })
  .forEach(printjson);

print("Category plan:");
printjson(db.products.find({ "category.slug": "electronics", active: true }).explain("executionStats"));
