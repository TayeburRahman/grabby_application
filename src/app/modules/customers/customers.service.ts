import httpStatus from "http-status";
import ApiError from "../../../errors/ApiError";
import { ICustomer } from "./customers.interface";
import Customer from "./customers.model";
import { Branch } from "../shop_owner/shop_owner.model";
import { Menu } from "../menu/menu.model";
import { MenuCategory } from "../menu_category/menu_category.model";
import { MenuService } from "../menu/menu.service";
import { CustomerStampService } from "../customer_stamps/customer_stamps.service";
import QueryBuilder from "../../../builder/QueryBuilder";

const updateProfile = async (
  userId: string,
  payload: Partial<ICustomer>,
  profileImageFile?: any
) => {
  const customer = await Customer.findById(userId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  if (profileImageFile) {
    payload.profile_image = `/images/profile/${profileImageFile.filename}`;
  }

  const updatedCustomer = await Customer.findByIdAndUpdate(userId, payload, {
    new: true,
    runValidators: true,
  }).populate({
    path: "authId",
    select: "role"
  });

  await Customer.findByIdAndUpdate(updatedCustomer?.authId, payload)

  return updatedCustomer;
};

const getMyProfile = async (userId: string) => {
  const customer = await Customer.findById(userId).populate({
    path: "authId",
    select: "role"
  });
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }
  return customer;
};

const deg2rad = (deg: number) => deg * (Math.PI / 180);

const getDistanceInKm = (lat1: number, lon1: number, lat2: number, lon2: number) => {
  const R = 6371; // Radius of the earth in km
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

const formatTimeAMPM = (timeStr: string) => {
  if (!timeStr) return "";
  let [h, m] = timeStr.split(':');
  let hours = parseInt(h);
  const minutes = m ? m.trim().substring(0, 2) : "00";
  if (isNaN(hours)) return timeStr;
  const ampm = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  hours = hours ? hours : 12;
  return `${hours}:${minutes} ${ampm}`;
};

const getBranchStatusAndTiming = (availability: any[]) => {
  const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  const todayName = days[new Date().getDay()];
  const todayAvail = availability?.find((a: any) => a.day === todayName);

  let isOpen = false;
  let statusText = "Closed";
  let timing = "Closed Today";

  if (todayAvail && !todayAvail.isClosed && todayAvail.open && todayAvail.close) {
    timing = `Open: ${formatTimeAMPM(todayAvail.open)} - ${formatTimeAMPM(todayAvail.close)}`;

    const now = new Date();
    const currentTime = now.getHours() * 60 + now.getMinutes();

    const parseTime = (timeStr: string) => {
      if (!timeStr) return 0;
      const parts = timeStr.split(':');
      const h = parseInt(parts[0]);
      const m = parseInt(parts[1]);
      return (isNaN(h) ? 0 : h) * 60 + (isNaN(m) ? 0 : m);
    };

    const openTime = parseTime(todayAvail.open);
    const closeTime = parseTime(todayAvail.close);

    if (currentTime >= openTime && currentTime <= closeTime) {
      isOpen = true;
      statusText = "Open Now";
    } else {
      isOpen = false;
      statusText = "Closed";
    }
  }

  return { isOpen, statusText, timing };
};

const processBranchData = (branch: any, lat?: number, lon?: number) => {
  let distanceKm = null;
  let distanceText = "";
  if (lat && lon && branch.lat && branch.lng) {
    distanceKm = getDistanceInKm(lat, lon, branch.lat, branch.lng);
    distanceText = `${distanceKm.toFixed(1)} km`;
  }

  const { isOpen, statusText, timing } = getBranchStatusAndTiming(branch.availability);

  return {
    _id: branch._id,
    branch_name: branch.branch_name,
    shop_name: branch.shopOwnerId?.shop_name,
    image: branch.shopOwnerId?.profile_image || branch.shopOwnerId?.shop_logo || null,
    address: branch.address,
    distance: distanceKm,
    distanceText: distanceText || "",
    isOpen,
    statusText,
    timing,
    tags: ["Car", "Counter"],
    lat: branch.lat,
    lng: branch.lng,
  };
};

/*** Get branches based on customer address (lat, lon) 
 * Sorts branches by proximity to the customer if coordinates are provided 
 */

const getBranchesForCustomer = async (lat?: number, lon?: number) => {
  const branches = await Branch.find({}).populate("shopOwnerId", "shop_name shop_logo profile_image");

  const processedBranches = branches.map((branch: any) => processBranchData(branch, lat, lon));

  if (lat && lon) {
    return processedBranches.sort((a, b) => (a.distance || 0) - (b.distance || 0));
  }

  return processedBranches;
};

const getSingleBranch = async (
  branchId: string,
  lat?: number,
  lon?: number,
  categoryId?: string,
  query: Record<string, unknown> = {},
  customerAuthId?: string
) => {
  const branch = await Branch.findById(branchId).populate("shopOwnerId", "shop_name shop_logo profile_image");
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  const formattedBranch: any = processBranchData(branch, lat, lon);

  const shopOwnerId = (branch.shopOwnerId as any)?._id;

  let meta = null;

  if (shopOwnerId) {
    const categoryFilter: any = { shopOwnerId };
    if (categoryId) {
      categoryFilter._id = categoryId;
    }
    const categories = await MenuCategory.find(categoryFilter);

    const menuFilter: any = { shopOwnerId, isAvailable: true };
    if (categoryId) {
      menuFilter.category = categoryId;
    }

    const menuQuery = new QueryBuilder(Menu.find(menuFilter).populate("category"), query)
      .sort()
      .paginate()
      .fields();

    const rawMenus = await menuQuery.modelQuery;
    meta = await menuQuery.countTotal();

    const menus = await MenuService.attachActiveEvents(rawMenus, shopOwnerId.toString());

    const branchStampData = customerAuthId
      ? await CustomerStampService.getCustomerStampsByBranch(customerAuthId, branchId)
      : { totalStamps: 0 };
    const branchTotalStamps = branchStampData.totalStamps || 0;

    const categoriesWithMenus = categories.map((cat: any) => {
      return {
        _id: cat._id,
        name: cat.name,
        menus: menus
          .filter((m: any) => m.category?._id?.toString() === cat._id.toString())
          .map((menu: any) => {
            const menuObj = menu?.toObject ? menu.toObject() : menu;
            return {
              ...menuObj,
              totalStamps: branchTotalStamps,
              isFree: (menuObj.stamp || 0) > 0 && branchTotalStamps >= (menuObj.stamp || 0),
              remainingStamps: branchTotalStamps - (menuObj.stamp || 0),
            };
          })
      };
    });

    formattedBranch.totalStamps= branchTotalStamps
    // Filter out categories that have no menus (especially important when paginating)
    formattedBranch.menu_categories = categoriesWithMenus.filter(cat => cat.menus.length > 0);
  } else {
    formattedBranch.menu_categories = [];
  }

  return { branch: formattedBranch, meta };
};

const getBranchDetailsBrief = async (branchId: string, lat?: number, lon?: number) => {
  const branch = await Branch.findById(branchId).populate("shopOwnerId", "shop_name shop_logo profile_image");
  if (!branch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Branch not found");
  }

  return processBranchData(branch, lat, lon);
};

const saveLocation = async (
  userId: string,
  payload: { addressName: string; lat: number; lon: number }
) => {
  const customer = await Customer.findById(userId);
  if (!customer) {
    throw new ApiError(httpStatus.NOT_FOUND, "Customer not found");
  }

  const updatedCustomer = await Customer.findByIdAndUpdate(userId, payload, {
    new: true,
    runValidators: true,
  });

  return updatedCustomer;
};

export const CustomerService = {
  updateProfile,
  getMyProfile,
  saveLocation,
  getBranchesForCustomer,
  getSingleBranch,
  getBranchDetailsBrief,
};

