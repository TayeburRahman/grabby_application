/* eslint-disable @typescript-eslint/no-explicit-any */
import type { ColumnDef } from "@tanstack/react-table";
import { Badge } from "@/components/ui/badge";
import { ShopOwnerViewModal } from "./shop-owner-view-modal";

export type ShopOwner = {
  _id: string;
  name: string;
  shop_name: string;
  email: string;
  phone_number: string;
  approval_status: "pending" | "approved" | "rejected";
  status: "active" | "deactivate";
  createdAt: string;
  shop_license_number?: string;
  location?: {
    address?: string;
  };
  business_license?: string;
  authId?: {
    is_block: boolean;
  };
};

export const shopOwnersColumns = (
  onSuccess: () => void
): ColumnDef<ShopOwner>[] => [
  {
    accessorKey: "shop_name",
    header: "Shop Name",
    cell: ({ row }) => (
      <span className="text-sm font-semibold text-foreground uppercase tracking-tight">
        {row.original.shop_name || "N/A"}
      </span>
    ),
  },
  {
    accessorKey: "name",
    header: "Owner",
    cell: ({ row }) => (
      <div className="flex flex-col">
        <span className="text-sm font-medium text-foreground">
          {row.original.name}
        </span>
        <span className="text-xs text-muted-foreground italic">
          {row.original.email}
        </span>
      </div>
    ),
  },
  {
    accessorKey: "phone_number",
    header: "Phone",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground font-mono">
        {row.original.phone_number}
      </span>
    ),
  },
  {
    accessorKey: "createdAt",
    header: "Joined Date",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground whitespace-nowrap">
        {new Date(row.original.createdAt).toLocaleDateString()}
      </span>
    ),
  },
  {
    accessorKey: "approval_status",
    header: "Approval",
    cell: ({ row }) => {
      const status = row.original.approval_status;
      let variant: "destructive" | "warning" | "success" | "default" = "default";

      switch (status) {
        case "pending":
          variant = "warning";
          break;
        case "approved":
          variant = "success";
          break;
        case "rejected":
          variant = "destructive";
          break;
      }

      return (
        <Badge variant={variant as any} className="uppercase text-[10px] font-black tracking-widest">
          {status}
        </Badge>
      );
    },
  },
  {
    accessorKey: "status",
    header: "Account Status",
    cell: ({ row }) => {
      const isBlocked = row.original.authId?.is_block;
      return (
        <Badge variant={isBlocked ? "destructive" : "success"} className="uppercase text-[10px] font-black tracking-widest">
          {isBlocked ? "Blocked" : "Active"}
        </Badge>
      );
    },
  },
  {
    id: "actions",
    header: () => <div className="text-right mr-4">Actions</div>,
    cell: ({ row }) => (
      <div className="flex justify-end pr-2">
        <ShopOwnerViewModal shopOwner={row.original} onSuccess={onSuccess} />
      </div>
    ),
  },
];
