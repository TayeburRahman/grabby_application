import { type ColumnDef } from "@tanstack/react-table";
import { Badge } from "@/components/ui/badge";
import { Upload } from "lucide-react";
import { ProductViewModal } from "./view-modal";
import { API_BASE_URL } from "@/services/auth";

export type Product = {
  _id: string;
  itemName: string;
  category?: {
    _id: string;
    name: string;
  };
  description: string;
  price: number;
  isAvailable: boolean;
  image?: string;
  shopOwnerId?: {
    _id: string;
    name: string;
    shop_name: string;
  };
};

export const productsColumns: ColumnDef<Product>[] = [
  {
    accessorKey: "shopOwnerId",
    header: "SHOP / OWNER",
    cell: ({ row }) => (
      <div className="flex flex-col gap-0.5">
        <span className="font-bold text-primary text-sm uppercase tracking-tighter">
          {row.original.shopOwnerId?.shop_name || "Official Store"}
        </span>
        <span className="text-[10px] text-muted-foreground italic">
          by {row.original.shopOwnerId?.name || "Ayah Admin"}
        </span>
      </div>
    ),
  },
  {
    accessorKey: "itemName",
    header: "ITEM NAME",
    cell: ({ row }) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-muted flex items-center justify-center border">
          {row.original.image ? (
            <img src={`${API_BASE_URL.replace("/api/v1", "")}${row.original.image}`} alt={row.original.itemName} className="h-full w-full object-cover rounded-lg" />
          ) : (
            <Upload className="h-5 w-5 text-muted-foreground" />
          )}
        </div>
        <span className="font-medium text-foreground">{row.original.itemName}</span>
      </div>
    ),
  },
  {
    accessorKey: "category",
    header: "CATEGORY",
    cell: ({ row }) => (
      <Badge variant="secondary" className="bg-primary/10 text-primary hover:bg-primary/20 border-none px-3 py-1">
        {row.original.category?.name || "Uncategorized"}
      </Badge>
    ),
  },
  {
    accessorKey: "description",
    header: "DESCRIPTION",
    cell: ({ row }) => (
      <span className="text-muted-foreground text-sm line-clamp-1 max-w-62.5">
        {row.original.description}
      </span>
    ),
  },
  {
    accessorKey: "price",
    header: "PRICE",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        AED {(Number(row.original.price) || 0).toFixed(2)}
      </span>
    ),
  },
  {
    accessorKey: "isAvailable",
    header: "STATUS",
    cell: ({ row }) => (
      <Badge variant={row.original.isAvailable ? "success" : "destructive"}>
        {row.original.isAvailable ? "Available" : "Unavailable"}
      </Badge>
    ),
  },
  {
    id: "actions",
    header: () => <div className="text-right mr-5">VIEW</div>,
    cell: ({ row }) => (
      <div className="flex justify-end">
        <ProductViewModal product={row.original} />
      </div>
    ),
  },
];
