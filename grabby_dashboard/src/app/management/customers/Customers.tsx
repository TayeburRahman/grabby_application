import { useState, useEffect, useCallback } from "react";
import PageLayout from "@/components/common/page-layout";
import PageHeader from "@/components/ui/custom/page-header";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Search, Loader2 } from "lucide-react";
import { DataTable } from "@/components/ui/custom/data-table";
import {
  customersColumns,
  type Customer,
} from "@/components/management/customers/customers-columns";
import { getAllCustomers, getCustomerOverview } from "@/services/customer";
import { ErrorToast } from "@/lib/utils";

const Customers = () => {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [meta, setMeta] = useState<any>(null);
  const [overview, setOverview] = useState<any>({
    totalCustomers: 0,
    activeCustomers: 0,
    averageOrder: 0,
  });

  // Debounce search term
  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedSearch(searchTerm);
      setPage(1); // Reset to page 1 on search
    }, 500);
    return () => clearTimeout(timer);
  }, [searchTerm]);

  const fetchOverview = useCallback(async () => {
    const result = await getCustomerOverview();
    if (result.success) {
      setOverview(result.data);
    }
  }, []);

  const fetchCustomers = useCallback(async () => {
    setLoading(true);
    const result = await getAllCustomers({
      page,
      limit,
      searchTerm: debouncedSearch,
    });

    if (result.success) {
      setCustomers(result.data);
      setMeta(result.meta);
    } else {
      ErrorToast(result.message || "Failed to fetch customers");
    }
    setLoading(false);
  }, [page, limit, debouncedSearch]);

  useEffect(() => {
    fetchOverview();
  }, [fetchOverview]);

  useEffect(() => {
    fetchCustomers();
  }, [fetchCustomers]);

  const onPaginationChange = (newPage: number, newLimit: number) => {
    setPage(newPage);
    setLimit(newLimit);
  };

  return (
    <PageLayout>
      <div className="flex flex-col md:flex-row gap-2 justify-between">
        <PageHeader
          title="Customers"
          description="Manage customer information and loyalty progress"
        />
        <div className="relative flex items-center">
          <Search className="absolute left-4 size-4 text-muted-foreground/50" />
          <Input
            placeholder="Search customers by name or email..."
            className="pl-11 w-full md:w-80 border-muted-foreground/20"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <Card>
          <CardContent>
            <p className="text-sm font-medium text-muted-foreground">
              Total Customers
            </p>
            <h3 className="text-3xl font-bold mt-1">{overview.totalCustomers}</h3>
          </CardContent>
        </Card>
        <Card>
          <CardContent>
            <p className="text-sm font-medium text-muted-foreground">
              Active Customers
            </p>
            <h3 className="text-3xl font-bold mt-1 text-green-600">{overview.activeCustomers}</h3>
          </CardContent>
        </Card>
        <Card>
          <CardContent>
            <p className="text-sm font-medium text-muted-foreground">
              Avg. Orders
            </p>
            <h3 className="text-3xl font-bold mt-1 text-primary">{overview.averageOrder}</h3>
          </CardContent>
        </Card>
      </div>

      {loading ? (
        <div className="flex items-center justify-center h-64">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      ) : (
        <DataTable 
          columns={customersColumns} 
          data={customers} 
          meta={meta}
          onPaginationChange={onPaginationChange}
        />
      )}
    </PageLayout>
  );
};

export default Customers;
