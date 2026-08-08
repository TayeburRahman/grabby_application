import { Bell, Moon, Sun, Menu, LogOutIcon, ChevronDown } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { useTheme } from "@/theme/theme-provider";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
// import { useSelector } from "react-redux";
// import { useGetAdminProfileQuery } from "@/redux/feature/auth/authApi";
import { getInitials } from "@/lib/utils";
import { Skeleton } from "@/components/ui/skeleton";

import { useState, useEffect } from "react";
import { getMyProfile } from "@/services/auth";

interface AdminData {
  name: string;
  email: string;
  profile_image?: string;
  role?: string;
  authId?: {
    role: string;
  };
}

const Header = ({ onMenuClick }: { onMenuClick: () => void }) => {
  const { setTheme, theme } = useTheme();
  const [admin, setAdmin] = useState<AdminData | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchProfile = async () => {
      setIsLoading(true);
      const res = await getMyProfile();
      if (res.success && res.data) {
        setAdmin(res.data);
      }
      setIsLoading(false);
    };

    fetchProfile();
  }, []);

  const handleLogout = () => {
    localStorage.removeItem("accessToken");
    window.location.href = "/auth/login";
  };

  return (
    <header className="fixed top-0 right-0 left-0 lg:left-64 h-20 bg-card">
      <div className="h-full flex items-center justify-between px-6">
        {/* Left side: Branch Selector & Mobile Menu */}
        <div className="flex items-center gap-4">
          <Button
            variant="ghost"
            size="icon"
            className="lg:hidden"
            onClick={onMenuClick}
          >
            <Menu />
          </Button>


        </div>

        {/* Right side: Search, Notifications, Profile */}
        <div className="flex items-center gap-6">


          <div className="flex items-center gap-4">
            {/* Notification icon */}
            <Button variant="ghost" size="icon-sm" className="rounded-full" asChild>
              <Link to="/notifications" className="relative">
                <Bell />
                <span className="absolute top-1 right-1 h-2 w-2 bg-red-500 rounded-full border-2 border-background"></span>
              </Link>
            </Button>

            {/* Theme toggle */}
            <Button
              variant="ghost"
              size="icon-sm"
              className="rounded-full"
              onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
            >
              {theme === "dark" ? <Sun /> : <Moon />}
            </Button>

            {/* Profile dropdown */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <div className="flex items-center gap-3 cursor-pointer hover:opacity-90 transition-opacity pl-2">
                  {isLoading ? (
                    <>
                      <Skeleton className="h-11 w-11 rounded-xl" />
                      <div className="hidden lg:flex flex-col gap-1">
                        <Skeleton className="h-4 w-24" />
                        <Skeleton className="h-3 w-16" />
                      </div>
                    </>
                  ) : (
                    <>
                      <div className="relative">
                        <Avatar>
                          <AvatarImage src={admin?.profile_image} alt={admin?.name} />
                          <AvatarFallback>
                            {getInitials(admin?.name || "")}
                          </AvatarFallback>
                        </Avatar>
                      </div>
                      <div className="hidden lg:flex items-center gap-3">
                        <div className="flex flex-col text-left">
                          <span className="text-sm font-bold text-foreground leading-none mb-1">
                            {admin?.name}
                          </span>
                          <span className="text-[11px] font-medium text-muted-foreground capitalize">
                            {admin?.authId?.role?.replace("_", " ") || "Admin"}
                          </span>
                        </div>
                        <ChevronDown className="h-4 w-4 text-muted-foreground" />
                      </div>
                    </>
                  )}
                </div>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuLabel className="flex flex-col">
                  <span className="text-sm font-bold text-foreground">{admin?.name}</span>
                  <span className="text-xs font-medium text-muted-foreground mt-0.5">{admin?.email}</span>
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuGroup>
                  <DropdownMenuItem asChild>
                    <Link to="/settings/profile" className="flex items-center w-full">
                      Profile Settings
                    </Link>
                  </DropdownMenuItem>
                  <DropdownMenuItem onClick={handleLogout} className="text-red-500 focus:text-red-500">
                    <LogOutIcon className="mr-2 h-4 w-4" />
                    Logout
                  </DropdownMenuItem>
                </DropdownMenuGroup>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
