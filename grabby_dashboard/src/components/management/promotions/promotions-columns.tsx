import { type ColumnDef } from "@tanstack/react-table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Trash2, Calendar, Edit } from "lucide-react";
import { ConfirmationModal } from "@/components/ui/custom/confirmation-modal";
import { PromotionModal } from "./promotion-modal";

export type Promotion = {
  _id: string;
  code: string;
  shopOwnerId: {
    _id: string;
    name: string;
    shop_name: string;
  };
  status: "active" | "inactive";
  discountPercent: number;
  branchIds: string[] | "all";
  createdAt: string;
};

export const promotionsColumns = (
  onDelete: (id: string) => void,
  onStatusChange: (id: string, status: string) => void,
  onSuccess: () => void
): ColumnDef<Promotion>[] => [
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
    accessorKey: "code",
    header: "PROMO CODE",
    cell: ({ row }) => (
      <Badge variant="secondary" className="bg-muted text-primary font-black px-3 py-1 border-none uppercase text-xs tracking-widest ring-1 ring-primary/10">
        {row.getValue("code")}
      </Badge>
    ),
  },
  {
    accessorKey: "discountPercent",
    header: "DISCOUNT",
    cell: ({ row }) => (
      <div className="flex items-center gap-2">
        <div className="h-8 w-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-black text-xs">
          %
        </div>
        <span className="font-bold text-foreground text-lg">
          {row.getValue("discountPercent")}% OFF
        </span>
      </div>
    ),
  },
  {
    accessorKey: "createdAt",
    header: "CREATED AT",
    cell: ({ row }) => (
      <div className="flex items-center gap-2 text-muted-foreground text-xs font-medium">
        <Calendar className="h-3.5 w-3.5" />
        {new Date(row.original.createdAt).toLocaleDateString()}
      </div>
    ),
  },
  {
    accessorKey: "status",
    header: "STATUS",
    cell: ({ row }) => {
      const status = row.getValue("status") as string;
      return (
        <Badge 
          variant={status === "active" ? "success" : "destructive"}
          className="cursor-pointer uppercase text-[10px] font-black tracking-widest"
          onClick={() => onStatusChange(row.original._id, status === "active" ? "inactive" : "active")}
        >
          {status}
        </Badge>
      );
    },
  },
  {
    id: "actions",
    header: () => <div className="text-right mr-4">ACTIONS</div>,
    cell: ({ row }) => (
      <div className="flex items-center justify-end gap-2 pr-2">
        <PromotionModal 
          mode="edit" 
          promotion={row.original} 
          onSuccess={onSuccess}
          trigger={
            <Button variant="ghost" size="icon" className="h-8 w-8 hover:bg-primary/10 hover:text-primary transition-all">
              <Edit className="h-4 w-4" />
            </Button>
          } 
        />
        <ConfirmationModal
          title="Delete Promo Code"
          description={`Are you sure you want to delete the code "${row.original.code}"? This action cannot be undone.`}
          onConfirm={() => onDelete(row.original._id)}
          trigger={
            <Button variant="ghost" size="icon" className="h-8 w-8 text-destructive hover:bg-destructive/10 transition-all">
              <Trash2 className="h-4 w-4" />
            </Button>
          }
        />
      </div>
    ),
  },
];
