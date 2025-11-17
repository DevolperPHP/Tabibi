const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
let serviceAccount;

try {
  // Try to load from environment variable path
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    serviceAccount = require(process.env.GOOGLE_APPLICATION_CREDENTIALS);
  } else {
    // Try to load from default location
    serviceAccount = require(path.join(__dirname, '../config/serviceAccountKey.json'));
  }

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
  console.log('Firebase Admin initialized successfully');
} catch (error) {
  console.error('Error initializing Firebase Admin:', error.message);
  console.log('Please make sure you have:');
  console.log('1. Downloaded the service account key from Firebase Console');
  console.log('2. Saved it as config/serviceAccountKey.json');
  console.log('3. Or set GOOGLE_APPLICATION_CREDENTIALS environment variable');
}

class FCMService {
  /**
   * Send push notification to a single device
   * @param {string} token - FCM token of the device
   * @param {string} title - Notification title
   * @param {string} body - Notification body
   * @param {object} data - Additional data to send
   */
  static async sendToDevice(token, title, body, data = {}) {
    try {
      const message = {
        notification: {
          title: title,
          body: body,
        },
        data: data,
        token: token,
      };

      const response = await admin.messaging().send(message);
      console.log('Successfully sent message:', response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error('Error sending message:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send push notification to multiple devices
   * @param {Array<string>} tokens - Array of FCM tokens
   * @param {string} title - Notification title
   * @param {string} body - Notification body
   * @param {object} data - Additional data to send
   */
  static async sendToMultipleDevices(tokens, title, body, data = {}) {
    try {
      const message = {
        notification: {
          title: title,
          body: body,
        },
        data: data,
        tokens: tokens,
      };

      const response = await admin.messaging().sendMulticast(message);
      console.log('Successfully sent messages:', response.successCount, 'successes,', response.failureCount, 'failures');

      if (response.failureCount > 0) {
        const failedTokens = [];
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            failedTokens.push(tokens[idx]);
          }
        });
        console.log('List of tokens that caused failures:', failedTokens);
      }

      return {
        success: true,
        successCount: response.successCount,
        failureCount: response.failureCount,
        messageId: response.responses[0]?.messageId,
      };
    } catch (error) {
      console.error('Error sending messages:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send notification to a topic
   * @param {string} topic - Topic name
   * @param {string} title - Notification title
   * @param {string} body - Notification body
   * @param {object} data - Additional data to send
   */
  static async sendToTopic(topic, title, body, data = {}) {
    try {
      const message = {
        notification: {
          title: title,
          body: body,
        },
        data: data,
        topic: topic,
      };

      const response = await admin.messaging().send(message);
      console.log('Successfully sent message to topic:', response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error('Error sending message to topic:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Subscribe devices to a topic
   * @param {Array<string>} tokens - Array of FCM tokens
   * @param {string} topic - Topic name
   */
  static async subscribeToTopic(tokens, topic) {
    try {
      const response = await admin.messaging().subscribeToTopic(tokens, topic);
      console.log('Successfully subscribed to topic:', response.successCount, 'successes');
      return { success: true, response };
    } catch (error) {
      console.error('Error subscribing to topic:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Unsubscribe devices from a topic
   * @param {Array<string>} tokens - Array of FCM tokens
   * @param {string} topic - Topic name
   */
  static async unsubscribeFromTopic(tokens, topic) {
    try {
      const response = await admin.messaging().unsubscribeFromTopic(tokens, topic);
      console.log('Successfully unsubscribed from topic:', response.successCount, 'successes');
      return { success: true, response };
    } catch (error) {
      console.error('Error unsubscribing from topic:', error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Send case-related notification
   * @param {Array<string>} tokens - FCM tokens
   * @param {string} caseId - Case ID
   * @param {string} type - Case type (created, accepted, rejected, taken)
   * @param {string} patientName - Patient name
   */
  static async sendCaseNotification(tokens, caseId, type, patientName) {
    const messages = {
      case_created: {
        title: 'حالة جديدة',
        body: `تم إنشاء حالة جديدة من ${patientName}`,
        type: 'case_created',
      },
      case_accepted: {
        title: 'تم قبول الحالة',
        body: `تم قبول حالتك من قبل الدكتور`,
        type: 'case_accepted',
      },
      case_rejected: {
        title: 'تم رفض الحالة',
        body: `تم رفض حالتك`,
        type: 'case_rejected',
      },
      case_taken: {
        title: 'تم أخذ الحالة',
        body: `بدأ الدكتور بفحص حالتك`,
        type: 'case_taken',
      },
    };

    const message = messages[type];
    if (!message) {
      return { success: false, error: 'Invalid case type' };
    }

    return await this.sendToMultipleDevices(tokens, message.title, message.body, {
      type: message.type,
      relatedId: caseId,
    });
  }

  /**
   * Send health tip notification
   * @param {Array<string>} tokens - FCM tokens
   * @param {string} tipId - Health tip ID
   * @param {string} tipTitle - Health tip title
   */
  static async sendHealthTipNotification(tokens, tipId, tipTitle) {
    return await this.sendToMultipleDevices(
      tokens,
      'نصائح صحية',
      tipTitle,
      {
        type: 'teeth_health_tip',
        relatedId: tipId,
      }
    );
  }

  /**
   * Send appointment reminder
   * @param {Array<string>} tokens - FCM tokens
   * @param {string} appointmentId - Appointment ID
   * @param {string} appointmentTime - Appointment time
   */
  static async sendAppointmentReminder(tokens, appointmentId, appointmentTime) {
    return await this.sendToMultipleDevices(
      tokens,
      'تذكير بالموعد',
      `لديك موعد في ${appointmentTime}`,
      {
        type: 'appointment_reminder',
        relatedId: appointmentId,
      }
    );
  }
}

module.exports = FCMService;
