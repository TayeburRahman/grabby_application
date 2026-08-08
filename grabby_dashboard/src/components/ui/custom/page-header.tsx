

const PageHeader = ({ title, description, length }: { title: string, description: string, length?: number }) => {
    return (
        <div className="flex flex-col">
            <div className="flex items-center">
                <h1 className="text-xl font-bold tracking-widest uppercase text-foreground">{title}</h1>
                {length && (
                    <span className="inline-flex items-center justify-center rounded-full bg-primary/10 px-2.5 py-0.5 text-xs font-medium text-primary border border-primary/20">
                        {length}
                    </span>
                )}
            </div>
            <p className="text-sm text-muted-foreground max-w-150 leading-relaxed">
                {description}
            </p>
        </div>
    )
}

export default PageHeader