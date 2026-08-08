import { useEffect, useState, useCallback } from "react";
import PageLayout from "@/components/common/page-layout";
import PageHeader from "@/components/ui/custom/page-header";
import { DataTable } from "@/components/ui/custom/data-table";
import { adminColumns } from "@/components/management/admins/admin-columns";
import { AdminModal, type Admin } from "@/components/management/admins/admin-modal";
import { getAllAdmins } from "@/services/admin";
import { ErrorToast } from "@/lib/utils";
import { Loader2 } from "lucide-react";

const Admins = () => {
  const [admins, setAdmins] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [meta, setMeta] = useState({ page: 1, limit: 10, total: 0 });
  const [page, setPage] = useState(1);
  const [limit] = useState(10);

  const fetchAdmins = useCallback(async () => {
    setLoading(true);
    const result = await getAllAdmins({
      page,
      limit,
    });

    if (result.success) {
      setAdmins(result.data);
      setMeta(result.meta);
    } else {
      ErrorToast(result.message || "Failed to fetch admins");
    }
    setLoading(false);
  }, [page, limit]);

  useEffect(() => {
    fetchAdmins();
  }, [fetchAdmins]);

  return (
    <PageLayout>
      <div className="flex flex-col gap-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <PageHeader
            title="Admin Management"
            description="Manage system administrators and their roles"
          />
          <AdminModal mode="create" onSuccess={fetchAdmins} />
        </div>

        {/* Table Section */}
        {loading ? (
          <div className="h-[400px] flex items-center justify-center">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
          </div>
        ) : (
          <DataTable 
            columns={adminColumns(fetchAdmins)} 
            data={admins.map(admin => ({
              id: admin._id,
              name: admin.name,
              email: admin.email,
              role: (admin.authId?.role === 'SUPER_ADMIN' ? 'Super Admin' : 'Admin') as any,
              joinedDate: new Date(admin.createdAt).toLocaleDateString(),
            })) as Admin[]} 
            meta={meta}
            onPaginationChange={(newPage) => setPage(newPage)}
          />
        )}
      </div>
    </PageLayout>
  );
};

export default Admins;
