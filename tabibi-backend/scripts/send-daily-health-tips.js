// This script sends daily health tips to all users
// It can be run manually or scheduled via cron job

const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

// Load environment variables
dotenv.config({ path: path.join(__dirname, '../key.env') });

// Connect to database
mongoose.connect(process.env.MONGO_URL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

const User = require('../model/User');
const Notification = require('../model/Notification');

// Daily health tips - rotate through these
const healthTips = [
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'تذكر أن تنظف أسنانك مرتين يومياً لمدة دقيقتين على الأقل باستخدام معجون أسنان يحتوي على الفلورايد.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'استخدم خيط الأسنان يومياً لإزالة البلاك والطعام المتبقي بين الأسنان التي لا يمكن للفرشاة الوصول إليها.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'اشطف فمك بالماء بعد تناول الوجبات للمساعدة في إزالة جزيئات الطعام والبكتيريا.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'تجنب الأطعمة والمشروبات السكرية والحامضة للحفاظ على مينا أسنانك قوية.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'قم بزيارة طبيب الأسنان كل 6 أشهر للفحص والتنظيف الدوري للحفاظ على صحة فمك.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'استبدل فرشاة أسنانك كل 3-4 أشهر أو عند تلف الشعيرات لضمان التنظيف الفعال.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'اشرب الماء بكثرة طوال اليوم للحفاظ على ترطيب فمك وزيادة إنتاج اللعاب الطبيعي.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'تجنب استخدام الأسنان كـ"أدوات" لفتح العبوات أو كسر الأشياء الصلبة لتجنب الكسر.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'تناول الأطعمة الغنية بالكالسيوم مثل الحليب والجبن لبناء أسنان وعظام قوية.',
    },
    {
        title: 'نصيحة يومية لصحة الأسنان',
        body: 'إذا كنت تعاني من جفاف الفم، استخدم غسول الفم أو العلكة الخالية من السكر لتحفيز إنتاج اللعاب.',
    },
];

// Get random health tip
function getRandomHealthTip() {
    const randomIndex = Math.floor(Math.random() * healthTips.length);
    return healthTips[randomIndex];
}

async function sendDailyHealthTips() {
    try {
        console.log('Starting to send daily health tips...');

        // Get all users
        const users = await User.find({}).select('_id');
        const userIds = users.map(user => user._id.toString());

        if (userIds.length === 0) {
            console.log('No users found to send health tips to.');
            return;
        }

        // Get random health tip
        const healthTip = getRandomHealthTip();

        // Create notifications for all users
        const notifications = userIds.map(userId => ({
            userId,
            title: healthTip.title,
            body: healthTip.body,
            type: 'health_tip',
            relatedId: null,
        }));

        // Insert notifications
        await Notification.insertMany(notifications);

        console.log(`Successfully sent health tip to ${notifications.length} users`);
        console.log('Health tip:', healthTip.title);

        // Close database connection
        await mongoose.connection.close();
        console.log('Database connection closed.');
    } catch (error) {
        console.error('Error sending daily health tips:', error);
        process.exit(1);
    }
}

// Run the function
sendDailyHealthTips();
