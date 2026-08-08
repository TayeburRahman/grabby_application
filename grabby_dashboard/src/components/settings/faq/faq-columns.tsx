import type { ColumnDef } from "@tanstack/react-table";
import { Trash2, Edit } from "lucide-react";

import { Button } from "@/components/ui/button";
import AddFAQModal from "./add-faq-modal";
import { deleteFaq } from "@/services/faq";
import { ErrorToast, SuccessToast } from "@/lib/utils";

export type FAQ = {
  id: number;
  question: string;
  answer: string;
};

export const faqColumns = (onRefresh: () => void): ColumnDef<FAQ>[] => [
  {
    header: "Serial No.",
    accessorKey: "id",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        {row.index + 1}
      </span>
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "question",
    header: "Question",
    cell: ({ row }) => (
      <span className="text-sm font-medium text-foreground">
        {row.original.question}
      </span>
    ),
  },
  {
    accessorKey: "answer",
    header: "Answer",
    cell: ({ row }) => (
      <span className="text-sm text-muted-foreground line-clamp-2 max-w-100">
        {row.original.answer}
      </span>
    ),
  },
  {
    id: "actions",
    header: () => <div className="text-right pr-8">Actions</div>,
    cell: ({ row }) => {
      const handleDelete = async () => {
        if (window.confirm("Are you sure you want to delete this FAQ?")) {
          try {
            const response = await deleteFaq(row.original.id.toString());
            if (response?.success) {
              SuccessToast("FAQ deleted successfully");
              onRefresh();
            } else {
              ErrorToast(response?.message || "Failed to delete FAQ");
            }
          } catch (error: any) {
            ErrorToast(error?.message || "Failed to delete FAQ");
          }
        }
      };

      return (
        <div className="flex items-center justify-end gap-2 pr-4">
          <AddFAQModal mode="edit" faq={row.original} onSuccess={onRefresh}>
            <Button
              variant="ghost"
              size="icon"
              className="h-8 w-8 text-primary"
            >
              <Edit className="h-4 w-4" />
            </Button>
          </AddFAQModal>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 text-destructive"
            onClick={handleDelete}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      );
    },
  },
];
