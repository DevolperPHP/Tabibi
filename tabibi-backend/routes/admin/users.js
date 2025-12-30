const express = require('express');
const router = express.Router();
const isAdminMiddleware = require('../../middleware/isAdmin');
const User = require('../../model/User');

// Apply admin middleware to all routes
router.use(isAdminMiddleware);

/**
 * Get all users with optional search and filters
 * GET /admin/users
 * Query params: search (email/name), page, limit, isBanned
 */
router.get('/', async (req, res) => {
    try {
        const {
            search = '',
            page = 1,
            limit = 50,
            isBanned,
            sortBy = 'createdAt',
            order = 'desc'
        } = req.query;

        // Build query
        const query = {};

        // Search by email or name (case-insensitive)
        if (search) {
            query.$or = [
                { email: { $regex: search, $options: 'i' } },
                { name: { $regex: search, $options: 'i' } },
                { phone: { $regex: search, $options: 'i' } }
            ];
        }

        // Filter by banned status
        if (isBanned !== undefined) {
            query.isBanned = isBanned === 'true';
        }

        // Exclude admins from the list
        query.isAdmin = false;

        // Calculate pagination
        const pageNum = parseInt(page);
        const limitNum = parseInt(limit);
        const skip = (pageNum - 1) * limitNum;

        // Execute query with pagination
        const users = await User.find(query)
            .select('-password') // Exclude password
            .sort({ [sortBy]: order === 'desc' ? -1 : 1 })
            .skip(skip)
            .limit(limitNum)
            .lean();

        // Get total count for pagination
        const total = await User.countDocuments(query);

        // Enrich users with banned by admin name
        const enrichedUsers = await Promise.all(
            users.map(async (user) => {
                const userObj = { ...user };

                // Add banned by admin name if user is banned
                if (user.isBanned && user.bannedBy) {
                    const bannedByAdmin = await User.findById(user.bannedBy).select('name email');
                    userObj.bannedByName = bannedByAdmin ? bannedByAdmin.name : 'Unknown';
                }

                return userObj;
            })
        );

        res.status(200).json({
            users: enrichedUsers,
            pagination: {
                currentPage: pageNum,
                totalPages: Math.ceil(total / limitNum),
                totalUsers: total,
                pageSize: limitNum
            }
        });
    } catch (err) {
        console.error('Get Users Error:', err);
        res.status(500).json({ message: 'Server error while fetching users' });
    }
});

/**
 * Get a single user by ID
 * GET /admin/users/:id
 */
router.get('/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id).select('-password');

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Add banned by admin name if user is banned
        const userObj = user.toObject();
        if (user.isBanned && user.bannedBy) {
            const bannedByAdmin = await User.findById(user.bannedBy).select('name email');
            userObj.bannedByName = bannedByAdmin ? bannedByAdmin.name : 'Unknown';
        }

        res.status(200).json(userObj);
    } catch (err) {
        console.error('Get User Error:', err);
        res.status(500).json({ message: 'Server error while fetching user' });
    }
});

/**
 * Ban a user
 * PUT /admin/users/:id/ban
 * Body: { reason: string }
 */
router.put('/:id/ban', async (req, res) => {
    try {
        const { reason } = req.body;
        const userId = req.params.id;
        const adminId = req.user.id;

        // Find user
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Don't allow banning admins
        if (user.isAdmin) {
            return res.status(403).json({ message: 'Cannot ban admin users' });
        }

        // Check if already banned
        if (user.isBanned) {
            return res.status(400).json({ message: 'User is already banned' });
        }

        // Update user as banned
        user.isBanned = true;
        user.bannedAt = new Date();
        user.bannedBy = adminId;
        user.banReason = reason || 'Violation of terms';

        await user.save();

        // Send FCM notification to banned user
        const Notification = require('../../model/Notification');
        const FCMService = require('../../services/fcmService');

        await Notification.create({
            userId: userId,
            title: 'تم حظر حسابك ⛔',
            body: `سبب الحظر: ${reason || 'انتهاك قواعد المنصة'}. تواصل مع الإدارة للمزيد من المعلومات.`,
            type: 'user_banned',
        });

        // Send push notification
        if (user.fcmToken) {
            await FCMService.sendToDevice(
                user.fcmToken,
                'تم حظر حسابك ⛔',
                `سبب الحظر: ${reason || 'انتهاك قواعد المنصة'}. تواصل مع الإدارة للمزيد من المعلومات.`,
                {
                    type: 'user_banned',
                    banReason: reason || 'Violation of terms'
                }
            );
        }

        // Get admin name for response
        const admin = await User.findById(adminId).select('name');

        res.status(200).json({
            message: 'User banned successfully',
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                isBanned: user.isBanned,
                bannedAt: user.bannedAt,
                bannedByName: admin ? admin.name : 'Admin',
                banReason: user.banReason
            }
        });
    } catch (err) {
        console.error('Ban User Error:', err);
        res.status(500).json({ message: 'Server error while banning user' });
    }
});

/**
 * Unban a user
 * PUT /admin/users/:id/unban
 */
router.put('/:id/unban', async (req, res) => {
    try {
        const userId = req.params.id;

        // Find user
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Check if user is actually banned
        if (!user.isBanned) {
            return res.status(400).json({ message: 'User is not banned' });
        }

        // Update user as unbanned
        user.isBanned = false;
        user.bannedAt = null;
        user.bannedBy = null;
        user.banReason = null;

        await user.save();

        // Send FCM notification to unbanned user
        const Notification = require('../../model/Notification');
        const FCMService = require('../../services/fcmService');

        await Notification.create({
            userId: userId,
            title: 'تم إلغاء حظر حسابك ✅',
            body: 'تم إلغاء حظر حسابك بنجاح. يمكنك الآن تسجيل الدخول واستخدام التطبيق.',
            type: 'account_unbanned',
        });

        // Send push notification
        if (user.fcmToken) {
            await FCMService.sendToDevice(
                user.fcmToken,
                'تم إلغاء حظر حسابك ✅',
                'تم إلغاء حظر حسابك بنجاح. يمكنك الآن تسجيل الدخول واستخدام التطبيق.',
                {
                    type: 'account_unbanned'
                }
            );
        }

        res.status(200).json({
            message: 'User unbanned successfully',
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                isBanned: user.isBanned
            }
        });
    } catch (err) {
        console.error('Unban User Error:', err);
        res.status(500).json({ message: 'Server error while unbanning user' });
    }
});

/**
 * Delete a user
 * DELETE /admin/users/:id
 */
router.delete('/:id', async (req, res) => {
    try {
        const userId = req.params.id;

        // Find user
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Don't allow deleting admins
        if (user.isAdmin) {
            return res.status(403).json({ message: 'Cannot delete admin users' });
        }

        // Don't allow deleting yourself
        if (userId === req.user.id) {
            return res.status(403).json({ message: 'Cannot delete your own account' });
        }

        // Delete user
        await User.findByIdAndDelete(userId);

        res.status(200).json({
            message: 'User deleted successfully',
            userId: userId
        });
    } catch (err) {
        console.error('Delete User Error:', err);
        res.status(500).json({ message: 'Server error while deleting user' });
    }
});

module.exports = router;
