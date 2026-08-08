
import { type ColumnDef } from "@tanstack/react-table";
import { Badge } from "@/components/ui/badge";
import { Switch } from "@/components/ui/switch";
import { Input } from "@/components/ui/input";
import { Percent } from "lucide-react";

export interface ShopFee {
  id: string;
  name: string;
  ownerName: string;
  category: string;
  location: string;
  status: "Active" | "Inactive";
  joinedDate: string;
  feePercentage: number;
  isFeeActive: boolean;
  useGlobalFee: boolean;
}

interface ShopFeeColumnsProps {
  globalFee: number;
}

export const getShopFeeColumns = ({
  globalFee,
}: ShopFeeColumnsProps): ColumnDef<ShopFee>[] => [
  {
    accessorKey: "name",
    header: "SHOP NAME",
    cell: ({ row }) => (
      <div className="flex flex-col gap-0.5">
        <span className="font-bold text-foreground line-clamp-1">
          {row.original.name}
        </span>
        <span className="text-[10px] font-medium text-muted-foreground uppercase tracking-wider">
          {row.original.category}
        </span>
      </div>
    ),
  },
  {
    accessorKey: "ownerName",
    header: "OWNER",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-muted-foreground">
        {row.original.ownerName}
      </span>
    ),
  },
  {
    accessorKey: "isFeeActive",
    header: "FEE STATUS",
    cell: ({ row }) => (
      <div className="flex items-center gap-2">
        <Switch
          checked={row.original.isFeeActive}
          onCheckedChange={() => {}}
        />
        <span className="text-[10px] font-bold uppercase tracking-tight text-muted-foreground">
          {row.original.isFeeActive ? "Enabled" : "Bypassed"}
        </span>
      </div>
    ),
  },
  {
    accessorKey: "useGlobalFee",
    header: "FEE TYPE",
    cell: ({ row }) => (
      <div className="flex items-center gap-2">
        <Switch
          disabled={!row.original.isFeeActive}
          checked={row.original.useGlobalFee}
          onCheckedChange={() => {}}
        />
        <span className="text-[10px] font-bold uppercase tracking-tight text-muted-foreground">
          {row.original.useGlobalFee ? "Global" : "Custom"}
        </span>
      </div>
    ),
  },
  {
    id: "appliedFee",
    header: "APPLIED FEE",
    cell: ({ row }) => {
      const isBypassed = !row.original.isFeeActive;
      const isGlobal = row.original.useGlobalFee;

      return (
        <div className="flex items-center gap-2">
          <div className="relative w-20">
            <Input
              type="number"
              disabled={isBypassed || isGlobal}
              value={isBypassed ? 0 : isGlobal ? globalFee : row.original.feePercentage}
              onChange={() => {}}
              className={`h-8 pr-6 text-xs font-bold ${
                isBypassed
                  ? "bg-muted/50 text-muted-foreground/40 border-transparent"
                  : isGlobal
                  ? "bg-primary/5 text-primary border-primary/20"
                  : "text-foreground"
              }`}
            />
            <Percent
              className={`absolute right-1.5 top-1/2 -translate-y-1/2 h-3 w-3 ${
                isBypassed ? "text-muted-foreground/20" : "text-muted-foreground/60"
              }`}
            />
          </div>
        </div>
      );
    },
  },
  {
    accessorKey: "status",
    header: "STATUS",
    cell: ({ row }) => {
      const status = row.original.status;
      return (
        <Badge
          variant={status === "Active" ? "success" : "muted"}
          className="font-bold"
        >
          {status}
        </Badge>
      );
    },
  },
];

