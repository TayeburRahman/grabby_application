import { z } from 'zod';

const createFreeStructureZodSchema = z.object({
  body: z.object({
    content: z.string({
      required_error: 'Content is required',
    }),
  }),
});

const updateFreeStructureZodSchema = z.object({
  body: z.object({
    content: z.string().optional(),
  }),
});

export const FreeStructureValidation = {
  createFreeStructureZodSchema,
  updateFreeStructureZodSchema,
};
