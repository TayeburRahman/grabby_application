import PageLayout from "@/components/common/page-layout";
import { faqColumns, type FAQ } from "@/components/settings/faq/faq-columns";
import { FAQFilter } from "@/components/settings/faq/faq-filter";
import { DataTable } from "@/components/ui/custom/data-table";
import PageHeader from "@/components/ui/custom/page-header";
import { useEffect, useState } from "react";
import { getAllFaqs } from "@/services/faq";

const FAQPage = () => {
  const [faqs, setFaqs] = useState<FAQ[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  const fetchFaqs = async () => {
    try {
      setIsLoading(true);
      const response = await getAllFaqs();
      if (response?.success) {
        setFaqs(response.data || []);
      }
    } catch (error) {
      console.error("Error fetching faqs:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchFaqs();
  }, []);

  const meta = {
    total: faqs.length,
    page: 1,
    limit: 10,
    totalPages: Math.ceil(faqs.length / 10),
  };

  return (
    <PageLayout>
      <div className="flex flex-col md:flex-row md:justify-between gap-2">
        <PageHeader
          title="FAQ Management"
          description="Manage frequently asked questions"
        />
        <FAQFilter onAddSuccess={fetchFaqs} />
      </div>
      {isLoading ? (
        <div className="flex items-center justify-center min-h-[400px]">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : (
        <DataTable
          columns={faqColumns(fetchFaqs)}
          data={faqs}
          meta={meta}
        />
      )}
    </PageLayout>
  );
};

export default FAQPage;
