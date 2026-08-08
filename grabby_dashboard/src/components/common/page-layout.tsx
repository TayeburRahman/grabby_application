
const PageLayout = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="flex flex-col min-h-[calc(100vh-112px)] p-1">
      <div className="grid gap-6">{children}</div>
    </div>
  );
};

export default PageLayout;
