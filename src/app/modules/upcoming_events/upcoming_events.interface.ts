import { Model } from 'mongoose';

export type IUpcomingEvents = {
  name: string;
  icons: string[];
  startDate: string;
  endDate: string;
};

export type UpcomingEventsModel = Model<IUpcomingEvents>;
