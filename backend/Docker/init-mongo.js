// init-mongo.js - Initialize database with indexes

db = db.getSiblingDB('mentecart');

// Create indexes for Users collection
db.users.createIndex({ email: 1 }, { unique: true });

// Create indexes for Services collection
db.services.createIndex({ title: 'text', description: 'text' });
db.services.createIndex({ category: 1 });
db.services.createIndex({ isActive: 1 });

// Create indexes for ServiceSlots collection
db.serviceslots.createIndex({ serviceId: 1, date: 1 });
db.serviceslots.createIndex({ serviceId: 1, date: 1, isActive: 1 });
db.serviceslots.createIndex({ date: 1 });

// Create indexes for Carts collection
db.carts.createIndex({ userId: 1 }, { unique: true });

// Create indexes for Bookings collection
db.bookings.createIndex({ userId: 1, createdAt: -1 });
db.bookings.createIndex({ userId: 1, status: 1 });
db.bookings.createIndex({ createdAt: 1 });

console.log('✓ All indexes created successfully');