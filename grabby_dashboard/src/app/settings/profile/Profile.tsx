import { useEffect, useState } from "react";
import PageLayout from "@/components/common/page-layout";
import ChangePasswordForm from "@/components/settings/change-password-form";
import EditProfileForm from "@/components/settings/edit-profile-form";
import ProfileHeader from "@/components/settings/profile-header";
import { getMyProfile } from "@/services/auth";
import { Loader2 } from "lucide-react";

const Profile = () => {
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  const fetchProfile = async () => {
    setLoading(true);
    const result = await getMyProfile();
    if (result.success) {
      setUser(result.data);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchProfile();
  }, []);

  if (loading) {
    return (
      <PageLayout>
        <div className="h-[60vh] flex items-center justify-center">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      </PageLayout>
    );
  }

  return (
    <PageLayout>
      <div className="space-y-6">
        <ProfileHeader user={user} />
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <EditProfileForm initialData={user} onUpdate={fetchProfile} />
          <ChangePasswordForm />
        </div>
      </div>
    </PageLayout>
  );
};

export default Profile;
