import mongoose, { Document } from "mongoose";

export type ICarPlate = Document & {
  _id: mongoose.Schema.Types.ObjectId;
  customerId: mongoose.Schema.Types.ObjectId;
  carNumberSource: string;
  plateCode: string;
  createdAt?: Date;
  updatedAt?: Date;
};