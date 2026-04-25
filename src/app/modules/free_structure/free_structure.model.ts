import { Schema, model } from 'mongoose';
import { IFreeStructure, FreeStructureModel } from './free_structure.interface';

const freeStructureSchema = new Schema<IFreeStructure>(
  {
    content: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
    },
  }
);

export const FreeStructure = model<IFreeStructure, FreeStructureModel>('FreeStructure', freeStructureSchema);
