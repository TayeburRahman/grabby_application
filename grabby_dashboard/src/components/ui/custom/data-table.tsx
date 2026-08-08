
import * as React from "react";
import {
  flexRender,
  getCoreRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  useReactTable,
  type SortingState,
} from "@tanstack/react-table";
import type { ColumnDef } from "@tanstack/react-table";
import { ArrowUpDown, ArrowUp, ArrowDown } from "lucide-react";

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ScrollArea, ScrollBar } from "../scroll-area";
import { DataTablePagination } from "./data-table-pagination";

/* eslint-disable @typescript-eslint/no-unused-vars */
declare module "@tanstack/react-table" {
  interface ColumnMeta<TData, TValue> {
    headerClassName?: string;
  }
}
/* eslint-enable @typescript-eslint/no-unused-vars */

interface DataTableProps<TData, TValue> {
  columns: ColumnDef<TData, TValue>[];
  data: TData[];
  pageSize?: number;
  meta?: {
    total: number;
    page: number;
    limit: number;
    totalPages?: number;
  };
  onPaginationChange?: (page: number, limit: number) => void;
}

export function DataTable<TData, TValue>({
  columns,
  data,
  pageSize = 10,
  meta,
  onPaginationChange,
}: DataTableProps<TData, TValue>) {
  const [sorting, setSorting] = React.useState<SortingState>([]);

  // eslint-disable-next-line react-hooks/incompatible-library
  const table = useReactTable({
    data,
    columns,
    pageCount: meta 
      ? (meta.totalPages ?? Math.ceil(meta.total / meta.limit)) 
      : undefined,
    state: {
      sorting,
      ...(meta && {
        pagination: {
          pageIndex: meta.page - 1,
          pageSize: meta.limit,
        },
      }),
    },
    manualPagination: !!meta,
    onPaginationChange: (updater) => {
      if (onPaginationChange && meta) {
        if (typeof updater === 'function') {
          const newState = updater({
            pageIndex: meta.page - 1,
            pageSize: meta.limit,
          });
          onPaginationChange(newState.pageIndex + 1, newState.pageSize);
        }
      }
    },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    initialState: {
      pagination: { pageSize },
    },
  });

  return (
    <div className="space-y-4">
      <ScrollArea className="w-[calc(100vw-42px)] lg:w-[calc(100vw-300px)] rounded-lg border whitespace-nowrap">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map((headerGroup) => (
              <TableRow key={headerGroup.id}>
                {headerGroup.headers.map((header) => {
                  return (
                    <TableHead
                      key={header.id}
                      className={header.column.columnDef.meta?.headerClassName}
                    >
                      {header.isPlaceholder ? null : (
                        <div
                          className={
                            header.column.getCanSort()
                              ? "flex items-center gap-1 cursor-pointer select-none hover:text-foreground"
                              : ""
                          }
                          onClick={header.column.getToggleSortingHandler()}
                        >
                          {flexRender(
                            header.column.columnDef.header,
                            header.getContext()
                          )}
                          {header.column.getCanSort() && (
                            <span className="ml-1">
                              {header.column.getIsSorted() === "asc" && (
                                <ArrowUp className="h-3 w-3" />
                              )}
                              {header.column.getIsSorted() === "desc" && (
                                <ArrowDown className="h-3 w-3" />
                              )}
                              {!header.column.getIsSorted() && (
                                <ArrowUpDown className="h-3 w-3 opacity-50" />
                              )}
                            </span>
                          )}
                        </div>
                      )}
                    </TableHead>
                  );
                })}
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {table.getRowModel().rows?.length ? (
              table.getRowModel().rows.map((row) => (
                <TableRow
                  key={row.id}
                  data-state={row.getIsSelected() && "selected"}
                  className="h-14"
                >
                  {row.getVisibleCells().map((cell) => (
                    <TableCell key={cell.id}>
                      {flexRender(
                        cell.column.columnDef.cell,
                        cell.getContext()
                      )}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell
                  colSpan={columns.length}
                  className="h-24 text-center"
                >
                  No results.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
        <ScrollBar orientation="horizontal" />
      </ScrollArea>

      <React.Suspense fallback={null}>
        {meta && (
          <DataTablePagination table={table} meta={meta} />
        )}
      </React.Suspense>
    </div>
  );
}
