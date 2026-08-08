import { Schema, model } from 'mongoose';
import { IUpcomingEvents, UpcomingEventsModel } from './upcoming_events.interface';

const upcomingEventsSchema = new Schema<IUpcomingEvents, UpcomingEventsModel>(
  {
    name: { type: String, required: true },
    icons: { type: [String], default: [] },
    startDate: { type: String, required: true },
    endDate: { type: String, required: true },
  },
  { timestamps: true }
);

export const UpcomingEvents = model<IUpcomingEvents, UpcomingEventsModel>(
  'UpcomingEvents',
  upcomingEventsSchema
);
