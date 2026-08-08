/* eslint-disable @typescript-eslint/no-explicit-any */
import type { ColumnDef } from "@tanstack/react-table";
import { Ban, Trash2 } from "lucide-react";

import { Checkbox } from "@/components/ui/checkbox";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import NewsfeedViewModal from "./view-modal";

export type NewsfeedItem = {
  id: number;
  name: string;
  avatar: string;
  caption: string;
  date: string;
  views: string;
  accountType: "User" | "Trainer";
};

export const newsfeedColumns: ColumnDef<NewsfeedItem>[] = [
  {
    id: "select",
    header: ({ table }) => (
      <label className="flex items-center gap-2 cursor-pointer select-none">
        <span className="font-semibold">Select All</span>
        <Checkbox
          checked={table.getIsAllPageRowsSelected()}
          onCheckedChange={(value: boolean) =>
            table.toggleAllPageRowsSelected(!!value)
          }
          aria-label="Select all"
        />
      </label>
    ),
    cell: ({ row }) => (
      <Checkbox
        checked={row.getIsSelected()}
        onCheckedChange={(value: boolean) => row.toggleSelected(!!value)}
        aria-label="Select row"
      />
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "avatar",
    header: "Profile",
    cell: ({ row }) => (
      <Avatar>
        <AvatarImage src={row.original.avatar} alt={row.original.name} />
        <AvatarFallback>{row.original.name.charAt(0)}</AvatarFallback>
      </Avatar>
    ),
  },
  {
    accessorKey: "name",
    header: "Name",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        {row.original.name}
      </span>
    ),
  },
  {
    accessorKey: "caption",
    header: "Caption",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground">
        {row.original.caption}
      </span>
    ),
  },
  {
    accessorKey: "date",
    header: "Date",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground">{row.original.date}</span>
    ),
  },
  {
    accessorKey: "views",
    header: "Views",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground">
        {row.original.views}
      </span>
    ),
  },
  {
    accessorKey: "accountType",
    header: "Account Type",
    cell: ({ row }) => {
      const type = row.original.accountType;
      const variant = "success";
      return (
        <Badge
          variant={variant as any}
          className="rounded-full px-3 py-1 bg-emerald-50 dark:bg-emerald-900/20"
        >
          {type}
        </Badge>
      );
    },
  },
  {
    id: "actions",
    header: () => <div className="text-right pr-8">Actions</div>,
    cell: () => (
      <div className="flex items-center justify-end gap-1">
        <NewsfeedViewModal />
        <Button
          variant="outline"
          size="icon"
          className="text-amber-500 hover:text-amber-600"
        >
          <Ban />
        </Button>
        <Button
          variant="outline"
          size="icon"
          className="text-red-500 hover:text-red-600"
        >
          <Trash2 />
        </Button>
      </div>
    ),
    enableSorting: false,
    enableHiding: false,
  },
];
