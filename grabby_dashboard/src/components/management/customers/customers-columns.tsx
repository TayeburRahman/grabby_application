import type { ColumnDef } from "@tanstack/react-table";
import { Award } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import CustomerViewModal from "./view-modal";
import { Badge } from "@/components/ui/badge";

export type Customer = {
  _id: string;
  name: string;
  email: string;
  phone_number: string;
  profile_image?: string | null;
  status: "active" | "deactivate";
  pointWallet: number;
  credWallet: number;
  createdAt: string;
};

export const customersColumns: ColumnDef<Customer>[] = [
  {
    accessorKey: "name",
    header: "CUSTOMER",
    cell: ({ row }) => {
      const customer = row.original;
      return (
        <div className="flex items-center gap-3">
          <Avatar className="h-9 w-9">
            <AvatarFallback>{customer.name.substring(0, 2).toUpperCase()}</AvatarFallback>
          </Avatar>
          <span className="text-sm font-medium text-foreground">
            {customer.name}
          </span>
        </div>
      );
    },
  },
  {
    accessorKey: "pointWallet",
    header: "LOYALTY POINTS",
    cell: ({ row }) => (
      <div className="flex items-center gap-1 text-xs font-bold text-blue-600">
        <Award className="h-3.5 w-3.5" />
        {row.original.pointWallet ?? 0} pts
      </div>
    ),
  },
  {
    accessorKey: "credWallet",
    header: "CREDIT WALLET",
    cell: ({ row }) => {
      const customer = row.original;
      return (
        <span className="text-sm font-bold text-green-600">
          AED {(Number(customer.credWallet) || 0).toFixed(2)}
        </span>
      );
    },
  },
  {
    accessorKey: "status",
    header: "STATUS",
    cell: ({ row }) => (
      <Badge variant={row.original.status === "active" ? "success" : "destructive"}>
        {row.original.status}
      </Badge>
    ),
  },
  {
    accessorKey: "createdAt",
    header: "JOIN DATE",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground">
        {new Date(row.original.createdAt).toLocaleDateString()}
      </span>
    ),
  },
  {
    id: "actions",
    header: () => <div className="text-end mr-2">ACTIONS</div>,
    cell: ({ row }) => (
      <div className="text-end">
        <CustomerViewModal customer={row.original} />
      </div>
    ),
  },
];
