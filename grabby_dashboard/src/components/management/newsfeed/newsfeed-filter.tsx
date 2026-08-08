"use client";

import { Search } from "lucide-react";

import { Input } from "@/components/ui/input";

export const NewsfeedFilter = () => {
  return (
    <div className="flex flex-col gap-3 lg:flex-row lg:justify-end">
      {/* Center search + filter icon */}
      <div className="relative w-full md:w-65 h-8">
        <Search className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground z-10" />
        <Input placeholder="Search by name or email" className="pl-9 pr-3" />
      </div>

      {/* <Button variant="outline" className="rounded-full">
        <Download />
        Export
      </Button> */}
    </div>
  );
};
