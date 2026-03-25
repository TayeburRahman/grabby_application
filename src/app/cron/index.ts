import cron from 'node-cron';
import { EventOffer } from '../modules/event_offer/event_offer.model';
import { logger } from '../../shared/logger';

const updateExpiredEvents = async () => {
  try {
    const now = new Date();
    const result = await EventOffer.updateMany(
      {
        isActive: true,
        endDate: { $lt: now },
      },
      {
        $set: { isActive: false },
      }
    );

    if (result.modifiedCount > 0) {
      logger.info(`Cron: Deactivated ${result.modifiedCount} expired event offers.`);
    }
  } catch (error) {
    logger.error('Cron Error in updateExpiredEvents:', error);
  }
};

const initEventCron = () => {
  // Run every hour
  cron.schedule('0 * * * *', updateExpiredEvents);
  
  // Also run immediately on startup
  updateExpiredEvents();
};

export const CronJobs = {
  initEventCron,
};
