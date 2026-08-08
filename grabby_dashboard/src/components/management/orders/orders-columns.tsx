/* eslint-disable @typescript-eslint/no-explicit-any */
import type { ColumnDef } from "@tanstack/react-table";

import { Badge } from "@/components/ui/badge";
import { OrderViewModal } from "./order-view-modal";

export type OrderStatus = "placed" | "preparing" | "ready" | "completed" | "cancelled";

export type Order = {
  _id: string;
  orderId: string;
  customerId: {
    _id: string;
    name: string;
    email: string;
    phone_number: string;
  };
  branchId: {
    _id: string;
    branch_name: string;
    address: string;
  };
  items: Array<{
    menuName: string;
    quantity: number;
    totalPrice: number;
  }>;
  totalAmount: number;
  pickupType: "carPickup" | "counterPickup";
  carPlates?: string;
  status: OrderStatus;
  createdAt: string;
};

export const ordersColumns: ColumnDef<Order>[] = [
  {
    accessorKey: "orderId",
    header: "Order ID",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        #{row.original.orderId}
      </span>
    ),
  },
  {
    accessorKey: "createdAt",
    header: "Date",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground whitespace-nowrap">
        {new Date(row.original.createdAt).toLocaleDateString()}
      </span>
    ),
  },
  {
    accessorKey: "customerName",
    header: "Customer",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        {row.original.customerId?.name || "N/A"}
      </span>
    ),
  },
  {
    accessorKey: "items",
    header: "Items",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground">
        {row.original.items.map((item) => `${item.menuName} (x${item.quantity})`).join(", ")}
      </span>
    ),
  },
  {
    accessorKey: "totalAmount",
    header: "Total",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        AED {(Number(row.original.totalAmount) || 0).toFixed(2)}
      </span>
    ),
  },
  {
    accessorKey: "pickupType",
    header: "Pickup",
    cell: ({ row }) => (
      <Badge variant="secondary">
        {row.original.pickupType === "carPickup" ? "Car Pickup" : "Counter Pickup"}
      </Badge>
    ),
  },
  {
    accessorKey: "status",
    header: "Status",
    cell: ({ row }) => {
      const status = row.original.status;
      let variant: "destructive" | "warning" | "info" | "success" | "default" =
        "default";

      switch (status) {
        case "placed":
          variant = "destructive";
          break;
        case "preparing":
          variant = "warning";
          break;
        case "ready":
          variant = "info";
          break;
        case "completed":
          variant = "success";
          break;
        case "cancelled":
          variant = "secondary" as any;
          break;
      }

      return <Badge className="capitalize" variant={variant as any}>{status}</Badge>;
    },
  },
  {
    id: "actions",
    header: () => <div className="text-right">Actions</div>,
    cell: ({ row }) => (
      <div className="flex justify-end">
        <OrderViewModal order={row.original} />
      </div>
    ),
  },
];
