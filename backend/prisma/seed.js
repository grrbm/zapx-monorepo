import db from '../src/db.js';
import { hashingPassword } from '../src/services/auth.service.js';

/* Create Different User Types */
const createFirstAdmin = async () => {
  const email = process.env.ADMIN_EMAIL || 'admin@example.com';
  const password = process.env.ADMIN_PASSWORD || 'admin123';

  if (
    await db.user.findFirst({
      where: {
        email,
        deleted: false,
      },
    })
  ) {
    return console.log('Admin Already Exists!');
  }

  const hashedPassword = await hashingPassword({ password });

  const admin = await db.user.create({
    data: {
      username: 'admin',
      email,
      password: hashedPassword,
      role: 'ADMIN',
    },
  });
  return admin;
};

/* Create Consumer Users */
const createConsumers = async () => {
  const consumers = [
    {
      username: 'sarah_jones',
      fullName: 'Sarah Jones',
      email: 'sarah.jones@example.com',
      password: 'consumer123',
      phone: '+1-555-0101',
    },
    {
      username: 'mike_chen',
      fullName: 'Mike Chen',
      email: 'mike.chen@example.com',
      password: 'consumer123',
      phone: '+1-555-0102',
    },
    {
      username: 'emily_davis',
      fullName: 'Emily Davis',
      email: 'emily.davis@example.com',
      password: 'consumer123',
      phone: '+1-555-0103',
    }
  ];

  for (const consumerData of consumers) {
    const existingUser = await db.user.findFirst({
      where: { email: consumerData.email, deleted: false }
    });

    if (!existingUser) {
      const hashedPassword = await hashingPassword({ password: consumerData.password });
      
      const user = await db.user.create({
        data: {
          username: consumerData.username,
          fullName: consumerData.fullName,
          email: consumerData.email,
          password: hashedPassword,
          role: 'CONSUMER',
          isVerified: true,
        },
      });

      await db.consumer.create({
        data: {
          phone: consumerData.phone,
          userId: user.id,
        },
      });

      console.log(`Consumer '${consumerData.fullName}' created successfully`);
    } else {
      console.log(`Consumer '${consumerData.fullName}' already exists`);
    }
  }
};

/* Create Seller Users */
const createSellers = async () => {
  const sellers = [
    {
      username: 'alex_photo',
      fullName: 'Alex Rodriguez',
      email: 'alex.photo@example.com',
      password: 'seller123',
      aboutMe: 'Professional photographer specializing in weddings and portraits with 8+ years experience.',
      location: 'New York, NY',
      categoryName: 'Photography',
    },
    {
      username: 'jessica_video',
      fullName: 'Jessica Williams',
      email: 'jessica.video@example.com',
      password: 'seller123',
      aboutMe: 'Creative videographer focused on event recaps and social media content.',
      location: 'Los Angeles, CA',
      categoryName: 'Videography',
    },
    {
      username: 'david_studio',
      fullName: 'David Thompson',
      email: 'david.studio@example.com',
      password: 'seller123',
      aboutMe: 'Studio photographer specializing in headshots and product photography.',
      location: 'Chicago, IL',
      categoryName: 'Photography',
    },
    {
      username: 'maria_films',
      fullName: 'Maria Garcia',
      email: 'maria.films@example.com',
      password: 'seller123',
      aboutMe: 'Cinematic videographer creating beautiful wedding films and brand videos.',
      location: 'Miami, FL',
      categoryName: 'Videography',
    }
  ];

  for (const sellerData of sellers) {
    const existingUser = await db.user.findFirst({
      where: { email: sellerData.email, deleted: false }
    });

    if (!existingUser) {
      const hashedPassword = await hashingPassword({ password: sellerData.password });
      
      const user = await db.user.create({
        data: {
          username: sellerData.username,
          fullName: sellerData.fullName,
          email: sellerData.email,
          password: hashedPassword,
          role: 'SELLER',
          isVerified: true,
        },
      });

      const category = await db.category.findFirst({
        where: { name: sellerData.categoryName, deleted: false }
      });

      if (category) {
        await db.seller.create({
          data: {
            aboutMe: sellerData.aboutMe,
            location: sellerData.location,
            userId: user.id,
            categoryId: category.id,
          },
        });

        console.log(`Seller '${sellerData.fullName}' created successfully`);
      } else {
        console.log(`Category '${sellerData.categoryName}' not found for seller '${sellerData.fullName}'`);
      }
    } else {
      console.log(`Seller '${sellerData.fullName}' already exists`);
    }
  }
};

/* Create Additional Admin Users */
const createAdmins = async () => {
  const admins = [
    {
      username: 'super_admin',
      fullName: 'Super Administrator',
      email: 'superadmin@zapx.com',
      password: 'superadmin123',
    },
    {
      username: 'platform_admin',
      fullName: 'Platform Manager',
      email: 'platform@zapx.com',
      password: 'platform123',
    }
  ];

  for (const adminData of admins) {
    const existingUser = await db.user.findFirst({
      where: { email: adminData.email, deleted: false }
    });

    if (!existingUser) {
      const hashedPassword = await hashingPassword({ password: adminData.password });
      
      await db.user.create({
        data: {
          username: adminData.username,
          fullName: adminData.fullName,
          email: adminData.email,
          password: hashedPassword,
          role: 'ADMIN',
          isVerified: true,
        },
      });

      console.log(`Admin '${adminData.fullName}' created successfully`);
    } else {
      console.log(`Admin '${adminData.fullName}' already exists`);
    }
  }
};

const services = [
  // Videography
  { name: 'Event Recaps', type: 'Videography' },
  { name: 'Wedding Films', type: 'Videography' },
  { name: 'Real Estate Walkthroughs', type: 'Videography' },
  { name: 'Brand/Promotional Videos', type: 'Videography' },
  { name: 'Social Media Content', type: 'Videography' },
  { name: 'Music Videos', type: 'Videography' },
  { name: 'Interviews/Documentary', type: 'Videography' },
  { name: 'Behind-the-Scenes (BTS)', type: 'Videography' },
  { name: 'Reels/TikToks/Shorts', type: 'Videography' },
  { name: 'Sports Highlights', type: 'Videography' },
  { name: 'Drone Footage', type: 'Videography' },
  { name: 'Corporate/Business Shoots', type: 'Videography' },

  // Photography
  { name: 'Maternity', type: 'Photography' },
  { name: 'Graduation', type: 'Photography' },
  { name: 'Influencer/Content Creation', type: 'Photography' },
  { name: 'Portraits', type: 'Photography' },
  { name: 'Headshots', type: 'Photography' },
  { name: 'Real Estate', type: 'Photography' },
  { name: 'Birthday/Event', type: 'Photography' },
  { name: 'Engagement', type: 'Photography' },
  { name: 'Wedding', type: 'Photography' },
  { name: 'Travel/Lifestyle', type: 'Photography' },
  { name: 'Family', type: 'Photography' },
  { name: 'Fashion', type: 'Photography' },
  { name: 'Sports/Action', type: 'Photography' },
  { name: 'Product Photography', type: 'Photography' },
  { name: 'Pet Photography', type: 'Photography' },
];
const categories = [
  {
    name: 'Videography',
  },
  {
    name: 'Photography',
  },
];
const Venues = [
  { id: 1, name: 'Studio' },
  { id: 2, name: 'Indoor' },
  { id: 3, name: 'Outdoor' },
  { id: 4, name: 'Rooftop' },
  { id: 5, name: 'Home' },
  { id: 6, name: 'Public Space' },
  { id: 7, name: 'Event Hall' },
  { id: 8, name: 'Nature (parks, trails, beaches)' },
  { id: 9, name: 'Urban/Street' },
  { id: 10, name: 'Other' },
];

const Locations = [
  { id: 1, name: 'Professional' },
  { id: 2, name: 'Casual' },
  { id: 3, name: 'Scenic' },
  { id: 4, name: 'Industrial' },
  { id: 5, name: 'Minimalist' },
  { id: 6, name: 'Luxury' },
  { id: 7, name: 'Artistic' },
  { id: 8, name: 'Natural' },
  { id: 9, name: 'Themed' },
  { id: 10, name: 'Other' },
];
const createCategory = async () => {
  try {
    // Loop over each service item and create the service if it doesn't exist
    for (const item of categories) {
      const existingCategory = await db.category.findFirst({
        where: {
          name: item.name,
          deleted: false,
        },
      });

      if (!existingCategory) {
        // If service doesn't exist, create it
        await db.category.create({
          data: {
            name: item.name,
          },
        });
        console.log(`Category '${item.name}' created successfully`);
      } else {
        console.log(`Catagory '${item.name}' already exists`);
      }
    }
  } catch (error) {
    console.error('Error in create category seed:', error);
  }
};

const createServices = async () => {
  try {
    // Loop over each service item and create the service if it doesn't exist
    for (const item of services) {
      const existingService = await db.services.findFirst({
        where: {
          name: item.name,
          deleted: false,
        },
      });

      const findCategory = await db.category.findFirst({
        where: {
          name: item.type,
          deleted: false,
        },
      });

      if (!existingService) {
        // If service doesn't exist, create it
        await db.services.create({
          data: {
            name: item.name,
            Category: {
              connect: { id: findCategory?.id },
            },
          },
        });
        console.log(`Service '${item.name}' created successfully`);
      } else {
        console.log(`Service '${item.name}' already exists`);
      }
    }
  } catch (error) {
    console.error('Error in create services seed:', error);
  }
};

const createVenues = async () => {
  try {
    // Loop over each Venue item and create the Venue if it doesn't exist
    for (const item of Venues) {
      const existingVenue = await db.venue.findFirst({
        where: {
          name: item.name,
          deleted: false,
        },
      });

      if (!existingVenue) {
        // If Venue doesn't exist, create it
        await db.venue.create({
          data: {
            name: item.name,
          },
        });
        console.log(`Venue '${item.name}' created successfully`);
      } else {
        console.log(`Venue '${item.name}' already exists`);
      }
    }
  } catch (error) {
    console.error('Error in create Venue seed:', error);
  }
};

const createLocations = async () => {
  try {
    // Loop over each location item and create the location if it doesn't exist
    for (const item of Locations) {
      const existingLocation = await db.location.findFirst({
        where: {
          name: item.name,
          deleted: false,
        },
      });

      if (!existingLocation) {
        // If location doesn't exist, create it
        await db.location.create({
          data: {
            name: item.name,
          },
        });
        console.log(`Location '${item.name}' created successfully`);
      } else {
        console.log(`Location '${item.name}' already exists`);
      }
    }
  } catch (error) {
    console.error('Error in create Venue seed:', error);
  }
};
const deleteOldServices = async () => {
  try {
    // Delete all services that are not in the new list
    await db.services.updateMany({
      where: {
        deleted: false,
        NOT: {
          name: {
            in: services.map((service) => service.name),
          },
        },
      },
      data: { deleted: true },
    });
    console.log('Old services deleted successfully');
  } catch (error) {
    console.error('Error deleting old services:', error);
  }
};
async function main() {
  // Create base data first
  await createCategory();
  await createVenues();
  await createLocations();
  await createServices();
  await deleteOldServices();
  
  // Create users of different types
  await createFirstAdmin();
  await createAdmins();
  await createConsumers();
  await createSellers();
  
  console.log('✅ Database seeded with all user types!');
  console.log('\n📊 Created Users:');
  console.log('👑 ADMIN Users: admin@example.com, superadmin@zapx.com, platform@zapx.com');
  console.log('🛒 CONSUMER Users: sarah.jones@example.com, mike.chen@example.com, emily.davis@example.com');
  console.log('📸 SELLER Users: alex.photo@example.com, jessica.video@example.com, david.studio@example.com, maria.films@example.com');
  console.log('\n🔑 Default passwords:');
  console.log('- Admin: admin123 / superadmin123 / platform123');
  console.log('- Consumer: consumer123');
  console.log('- Seller: seller123');
}

main()
  .then(async () => {
    await db.$disconnect();
  })
  .catch(async (e) => {
    console.error('e', e);
    await db.$disconnect();
    process.exit(1);
  });
