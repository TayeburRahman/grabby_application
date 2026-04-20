import { z } from 'zod';

const createCarPlateSchema = z.object({
  body: z.object({
    carNumberSource: z.string({ required_error: 'Car number source is required' }),
    plateCode: z.string({ required_error: 'Plate code is required' }),
  }),
});

const updateCarPlateSchema = z.object({
  body: z.object({
    carNumberSource: z.string().optional(),
    plateCode: z.string().optional(),
  }),
});

export const CarPlateValidation = {
  createCarPlateSchema,
  updateCarPlateSchema,
};