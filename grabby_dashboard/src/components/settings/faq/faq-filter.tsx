"use client";

import AddFAQModal from "./add-faq-modal";

interface FAQFilterProps {
  onAddSuccess?: () => void;
}

export const FAQFilter = ({ onAddSuccess }: FAQFilterProps) => {
  return (
    <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between mb-6">

      <AddFAQModal onSuccess={onAddSuccess} />
    </div>
  );
};
