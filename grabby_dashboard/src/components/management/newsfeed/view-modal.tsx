"use client";

import { useState } from "react";
import { Eye } from "lucide-react";

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogPortal,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";

const fakePost = {
  trainerName: "Hilda Reinger",
  caption: "Lorem ipsum dolor",
  view: "1.2k",
  favourite: "1.2k",
  date: "11/4/2025",
  cover:
    "https://images.unsplash.com/photo-1758875568433-7b8301847439?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
};

const NewsfeedViewModal = () => {
  const [open, setOpen] = useState(false);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" size="icon">
          <Eye />
        </Button>
      </DialogTrigger>

      <DialogPortal>
        <DialogContent className="max-w-3xl p-0 overflow-hidden shadow-2xl">
          <div className="w-full h-52 md:h-64 bg-muted">
            <img
              src={fakePost.cover}
              alt={fakePost.trainerName}
              className="h-full w-full object-cover"
            />
          </div>

          <div className="px-10 py-8 space-y-4">
            <DialogHeader className="text-left">
              <DialogTitle className="text-xl font-semibold font-crimson">
                Newsfeed Details
              </DialogTitle>
            </DialogHeader>

            <div className="space-y-2 text-sm">
              <InfoRow label="Trainer Name" value={fakePost.trainerName} />
              <InfoRow label="Caption" value={fakePost.caption} />
              <InfoRow label="View" value={fakePost.view} />
              <InfoRow label="Favourite" value={fakePost.favourite} />
              <InfoRow label="Date" value={fakePost.date} />
            </div>
          </div>
        </DialogContent>
      </DialogPortal>
    </Dialog>
  );
};

export default NewsfeedViewModal;

const InfoRow = ({ label, value }: { label: string; value: string }) => (
  <div className="grid grid-cols-[160px_1fr] items-center gap-4">
    <p className="text-sm font-medium">{label}</p>
    <p className="text-sm text-muted-foreground">{value}</p>
  </div>
);

