
import Sidebar from "@/components/common/sidebar";
import Topbar from "@/components/common/header";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useState } from "react";
import { Outlet } from "react-router-dom";

const MainLayout = () => {
    const [isSidebarOpen, setIsSidebarOpen] = useState(false);

    return (
        <div className="flex h-screen overflow-hidden">
            <Sidebar isSidebarOpen={isSidebarOpen} setIsSidebarOpen={setIsSidebarOpen} />
            <div className="flex-1 flex flex-col relative lg:pl-64 h-screen overflow-hidden">
                <Topbar onMenuClick={() => setIsSidebarOpen(!isSidebarOpen)} />
                <div className="flex-1 min-h-0 mt-20 bg-background">
                    <ScrollArea
                        className="h-full p-4 lg:rounded-tl-2xl"
                        onClick={() => isSidebarOpen && setIsSidebarOpen(false)}>
                        <div className="min-h-full">
                            <Outlet />
                        </div>
                    </ScrollArea>
                </div>
            </div>
            {isSidebarOpen && <div className="fixed inset-0 bg-background/50 z-30 lg:hidden" onClick={() => setIsSidebarOpen(false)}></div>}
        </div>
    );
};

export default MainLayout;