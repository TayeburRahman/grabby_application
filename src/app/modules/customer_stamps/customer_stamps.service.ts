import CustomerStamp from "./customer_stamps.model";
import httpStatus from "http-status";
import AppError from "../../../errors/AppError";
import Customer from "../customers/customers.model";
import { Menu } from "../menu/menu.model";

const getCustomerStampsByBranch = async (authId: string, branchId: string) => {
  console.log('==', authId, branchId)
  const customer = await Customer.findOne({ authId });
  if (!customer) {
    throw new AppError(httpStatus.NOT_FOUND, "Customer not found");
  }

  const customerStamp = await CustomerStamp.findOne({
    customer: customer._id.toString(),
    branch: branchId,
  });

  console.log(customerStamp)

  return {
    totalStamps: customerStamp ? customerStamp.totalStamps : 0,
  };
};

const addStamp = async (authId: string, branchId: string, stamps: number) => {
  const customer = await Customer.findOne({ authId });
  if (!customer) {
    throw new AppError(httpStatus.NOT_FOUND, "Customer not found");
  }

  let customerStamp = await CustomerStamp.findOne({
    customer: customer._id,
    branch: branchId,
  });

  if (!customerStamp) {
    customerStamp = await CustomerStamp.create({
      customer: customer._id,
      branch: branchId,
      totalStamps: stamps,
    });
  } else {
    customerStamp.totalStamps += stamps;
    await customerStamp.save();
  }

  return customerStamp;
};

const checkEligibility = async (
  authId: string,
  branchId: string,
  menuId: string,
  stamps: number = 0
) => {
  console.log("===", authId, branchId, menuId, stamps);
  const customer = await Customer.findOne({ authId });
  if (!customer) {
    throw new AppError(httpStatus.NOT_FOUND, "Customer not found");
  }

  const menu = await Menu.findById(menuId);
  if (!menu) {
    throw new AppError(httpStatus.NOT_FOUND, "Menu not found");
  }

  const customerStamp = await CustomerStamp.findOne({
    customer: customer._id,
    branch: branchId,
  });

  const dbTotalStamps = customerStamp ? customerStamp.totalStamps : 0;

  const currentStamps = stamps > 0 ? stamps : dbTotalStamps;

  const requiredStamps = menu.stamp || 0;
  const isFree = requiredStamps > 0 && currentStamps >= requiredStamps;

  // Calculate remaining stamps if free, otherwise return current the session balance
  const remainingStamps = isFree ? currentStamps - requiredStamps : currentStamps;

  return {
    isFree,
    stamps: remainingStamps,
    requiredStampsForThisMenu: requiredStamps,
  };
};

export const CustomerStampService = {
  getCustomerStampsByBranch,
  addStamp,
  checkEligibility,
};
