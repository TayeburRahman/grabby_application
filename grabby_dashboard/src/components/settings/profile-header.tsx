import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Calendar, Mail, ShieldCheck, UserCog } from "lucide-react";
import { format } from "date-fns";

interface ProfileHeaderProps {
  user: any;
}

const ProfileHeader = ({ user }: ProfileHeaderProps) => {
  if (!user) return null;

  const role = user.authId?.role === "SUPER_ADMIN" ? "Super Admin" : "Admin";
  const initials = user.name?.split(" ").map((n: string) => n[0]).join("").toUpperCase() || "A";

  return (
    <Card className="mb-6 overflow-hidden border-none shadow-md bg-linear-to-r from-primary/10 via-background to-background">
      <CardContent className="p-8">
        <div className="flex flex-col md:flex-row items-center gap-8">
          <div className="relative group">
            <div className="absolute -inset-1 bg-linear-to-r from-primary to-purple-600 rounded-full blur-sm opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"></div>
            <Avatar className="h-28 w-28 border-4 border-background shadow-2xl relative">
              <AvatarImage src={user.profile_image} alt={user.name} className="object-cover" />
              <AvatarFallback className="text-3xl font-bold bg-primary/5 text-primary">
                {initials}
              </AvatarFallback>
            </Avatar>
            <div className="absolute bottom-1 right-1 h-5 w-5 bg-green-500 border-2 border-background rounded-full shadow-lg"></div>
          </div>
          
          <div className="flex-1 text-center md:text-left space-y-3">
            <div className="flex flex-col md:flex-row md:items-center gap-3">
              <h1 className="text-3xl font-black tracking-tight text-foreground">{user.name}</h1>
              <Badge variant="secondary" className="w-fit mx-auto md:mx-0 px-3 py-1 bg-primary/10 text-primary border-none font-bold uppercase tracking-widest text-[10px]">
                {role === "Super Admin" ? (
                  <ShieldCheck className="w-3 h-3 mr-1 inline" />
                ) : (
                  <UserCog className="w-3 h-3 mr-1 inline" />
                )}
                {role}
              </Badge>
            </div>
            
            <div className="flex flex-wrap justify-center md:justify-start gap-4 text-sm text-muted-foreground font-medium">
              <div className="flex items-center gap-2 px-3 py-1.5 bg-muted/50 rounded-full transition-colors hover:bg-muted">
                <Mail className="h-4 w-4 text-primary" />
                {user.email}
              </div>
              <div className="flex items-center gap-2 px-3 py-1.5 bg-muted/50 rounded-full transition-colors hover:bg-muted">
                <Calendar className="h-4 w-4 text-primary" />
                Joined {user.createdAt ? format(new Date(user.createdAt), "MMMM yyyy") : "N/A"}
              </div>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default ProfileHeader;
