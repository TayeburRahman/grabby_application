import mongoose, { Schema, Model } from "mongoose";
import { ICarPlate } from "./car_plates.interface";

const CarPlateSchema = new Schema<ICarPlate>(
  {
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Customer",
    },
    carNumberSource: {
      type: String,
      required: true,
    },
    plateCode: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

const CarPlate: Model<ICarPlate> = mongoose.model<ICarPlate>("CarPlate", CarPlateSchema);

export default CarPlate;