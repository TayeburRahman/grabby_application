
import type { Table } from "@tanstack/react-table";

import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { cn } from "@/lib/utils";

interface DataTablePaginationProps<TData> {
  table: Table<TData>;
  meta?: {
    total: number;
    page: number;
    limit: number;
    totalPages?: number;
  };
}

export function DataTablePagination<TData>({
  table,
  meta,
}: DataTablePaginationProps<TData>) {
  // Simple helper: just sync TanStack page index.
  const handlePageChange = (page: number) => {
    table.setPageIndex(page - 1);
  };

  const currentPage = table.getState().pagination.pageIndex + 1;
  const totalPages = table.getPageCount();

  // Build page number list with ellipsis
  const pages: (number | string)[] = [];
  if (totalPages <= 5) {
    for (let i = 1; i <= totalPages; i++) pages.push(i);
  } else {
    pages.push(1);
    if (currentPage > 3) pages.push("...");
    for (
      let i = Math.max(2, currentPage - 1);
      i <= Math.min(totalPages - 1, currentPage + 1);
      i++
    ) {
      pages.push(i);
    }
    if (currentPage < totalPages - 2) pages.push("...");
    pages.push(totalPages);
  }

  return (
    <div className="flex flex-col md:flex-row items-center justify-between gap-6 py-6 px-4 border-t border-muted-foreground/10 bg-muted/5">
      <div className="flex flex-col gap-1 text-center md:text-left">
        <p className="text-sm font-semibold text-foreground tracking-tight">
          Inventory Results
        </p>
        <p className="text-xs text-muted-foreground font-medium">
          {meta ? (
            <>
              Showing <span className="text-primary font-bold">{(meta.page - 1) * meta.limit + 1}</span> to{" "}
              <span className="text-primary font-bold">{Math.min(meta.page * meta.limit, meta.total)}</span> of{" "}
              <span className="text-primary font-bold">{meta.total}</span> entries
            </>
          ) : (
            "Displaying items"
          )}
        </p>
      </div>

      <div className="flex items-center bg-background/50 backdrop-blur-sm p-1.5 rounded-2xl border border-muted-foreground/10 shadow-sm">
        <Pagination>
          <PaginationContent className="gap-1.5">
            {/* Previous */}
            <PaginationItem>
              <PaginationPrevious
                onClick={(e) => {
                  e.preventDefault();
                  if (currentPage > 1) {
                    handlePageChange(currentPage - 1);
                  }
                }}
                className={cn(
                  "rounded-xl transition-all hover:bg-primary hover:text-primary-foreground border-none shadow-none",
                  !table.getCanPreviousPage() && "opacity-20 pointer-events-none"
                )}
              />
            </PaginationItem>

            {/* Page numbers + ellipsis */}
            <div className="hidden sm:flex items-center gap-1.5 px-2 border-x border-muted-foreground/10 mx-1">
              {pages.map((page, idx) => {
                if (page === "...") {
                  return (
                    <PaginationItem key={`ellipsis-${idx}`}>
                      <PaginationEllipsis className="text-muted-foreground/50" />
                    </PaginationItem>
                  );
                }

                const pageNum = page as number;
                const isActive = pageNum === currentPage;

                return (
                  <PaginationItem key={pageNum}>
                    <PaginationLink
                      onClick={(e) => {
                        e.preventDefault();
                        handlePageChange(pageNum);
                      }}
                      isActive={isActive}
                      size="icon"
                      className={cn(
                        "rounded-xl transition-all font-bold text-xs h-8 w-8",
                        isActive 
                          ? "bg-primary text-primary-foreground shadow-md shadow-primary/20 scale-110" 
                          : "hover:bg-muted text-muted-foreground border-none"
                      )}
                    >
                      {pageNum}
                    </PaginationLink>
                  </PaginationItem>
                );
              })}
            </div>

            {/* Mobile simplified view */}
            <div className="sm:hidden px-3 text-xs font-bold text-muted-foreground">
              {currentPage} / {totalPages}
            </div>

            {/* Next */}
            <PaginationItem>
              <PaginationNext
                onClick={(e) => {
                  e.preventDefault();
                  if (currentPage < totalPages) {
                    handlePageChange(currentPage + 1);
                  }
                }}
                className={cn(
                  "rounded-xl transition-all hover:bg-primary hover:text-primary-foreground border-none shadow-none",
                  !table.getCanNextPage() && "opacity-20 pointer-events-none"
                )}
              />
            </PaginationItem>
          </PaginationContent>
        </Pagination>
      </div>
    </div>
  );
}