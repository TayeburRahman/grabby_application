import PageLayout from "@/components/common/page-layout";
import PageHeader from "@/components/ui/custom/page-header";
import { Card, CardContent } from "@/components/ui/card";
import { BranchModal } from "@/components/management/branches/branch-modal";

const Branches = () => {
  return (
    <PageLayout>
      <div className="flex flex-col gap-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <PageHeader
            title="Branch Management"
            description="Manage all your branch locations"
          />
          <BranchModal mode="create" />
        </div>

        {/* Global Stats */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <Card>
            <CardContent>
              <div className="flex flex-col gap-1">
                <p className="text-sm font-medium text-muted-foreground">Total Branches</p>
                <p className="text-3xl font-bold">4</p>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent>
              <div className="flex flex-col gap-1">
                <p className="text-sm font-medium text-muted-foreground">Active Branches</p>
                <p className="text-3xl font-bold text-green-600">3</p>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent>
              <div className="flex flex-col gap-1">
                <p className="text-sm font-medium text-muted-foreground">Total Staff</p>
                <p className="text-3xl font-bold text-primary/60">36</p>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent>
              <div className="flex flex-col gap-1">
                <p className="text-sm font-medium text-muted-foreground">Today's Revenue</p>
                <p className="text-3xl font-bold text-green-600">AED 5622.25</p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </PageLayout>
  );
};

export default Branches;
