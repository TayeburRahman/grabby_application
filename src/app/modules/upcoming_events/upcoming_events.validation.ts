import { z } from 'zod';

const createUpcomingEventZodSchema = z.object({
  body: z.object({
    name: z.string({
      required_error: 'Name is required',
    }),
    icons: z.array(z.string()).optional(),
    startDate: z.string({
      required_error: 'Start date is required',
    }),
    endDate: z.string({
      required_error: 'End date is required',
    }),
  }),
});

const updateUpcomingEventZodSchema = z.object({
  body: z.object({
    name: z.string().optional(),
    icons: z.array(z.string()).optional(),
    startDate: z.string().optional(),
    endDate: z.string().optional(),
  }),
});

export const UpcomingEventsValidation = {
  createUpcomingEventZodSchema,
  updateUpcomingEventZodSchema,
};
