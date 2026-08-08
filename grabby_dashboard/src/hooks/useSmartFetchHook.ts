import { useState, useEffect, useMemo, useTransition, useCallback } from 'react';

// Generic API list response shape
export type ApiListResponse<T> = {
  data?: T[];
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
    totalPage?: number;
    [k: string]: unknown;
  };
};

/**
 * Internal debounce hook
 */
function useInternalDebounce<T>(value: T, delay = 400): T {
  const [debounced, setDebounced] = useState<T>(value);
  useEffect(() => {
    const id = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(id);
  }, [value, delay]);
  return debounced;
}

type BaseParams = { page?: number; limit?: number; searchTerm?: string };

// The hook returned values
export type UseSmartFetchReturn<P extends BaseParams, T> = {
  searchTerm: string;
  setSearchTerm: React.Dispatch<React.SetStateAction<string>>;
  currentPage: number;
  setCurrentPage: React.Dispatch<React.SetStateAction<number>>;
  pageSize: number;
  setPageSize: React.Dispatch<React.SetStateAction<number>>;
  data: T[];
  meta: ApiListResponse<T>["meta"];
  isLoading: boolean;
  isPending: boolean;
  isError: boolean;
  filterParams: Partial<P>;
  setFilterParams: React.Dispatch<React.SetStateAction<Partial<P>>>;
  resetFilters: () => void;
};

type QueryHook<P extends BaseParams, T> = (
  params: P
) => { data?: ApiListResponse<T>; isLoading: boolean; isError: boolean };

/**
 * useSmartFetchHook - Optimized for React 19
 * Handles pagination, debounced search, and generic filters.
 */
const useSmartFetchHook = <P extends BaseParams, T>(
  queryHook: QueryHook<P, T>,
  options: Partial<P> = {} as Partial<P>,
  initialParams: Partial<P> = {} as Partial<P>
): UseSmartFetchReturn<P, T> => {
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [pageSize, setPageSize] = useState<number>(options.limit || 10);
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [filterParams, setFilterParams] = useState<Partial<P>>(initialParams);
  
  // React 19 transition for non-blocking state updates
  const [isPending, startTransition] = useTransition();

  // Debounce search term and filter params
  const debouncedSearchTerm = useInternalDebounce<string>(searchTerm);
  const debouncedFilterParams = useInternalDebounce<Partial<P>>(filterParams);

  // Memoize query parameters to avoid unnecessary re-renders
  const queryParams = useMemo(() => {
    return {
      page: currentPage,
      limit: pageSize,
      searchTerm: debouncedSearchTerm,
      ...debouncedFilterParams,
      ...options,
    } as P;
  }, [currentPage, pageSize, debouncedSearchTerm, debouncedFilterParams, options]);

  // Execute the query hook
  const { data, isLoading, isError } = queryHook(queryParams);

  // React 19 best practice: Reset page to 1 when filters or search change
  // Wrapping in startTransition to keep the UI responsive
  useEffect(() => {
    startTransition(() => {
      setCurrentPage(1);
    });
  }, [debouncedSearchTerm, debouncedFilterParams]);

  // Reset all filters and search
  const resetFilters = useCallback(() => {
    startTransition(() => {
      setSearchTerm('');
      setFilterParams(initialParams);
      setCurrentPage(1);
    });
  }, [initialParams]);

  const list = useMemo(() => data?.data ?? [], [data?.data]);
  const meta = data?.meta;

  return {
    searchTerm,
    setSearchTerm,
    currentPage,
    setCurrentPage,
    pageSize,
    setPageSize,
    data: list,
    meta,
    isLoading,
    isPending,
    isError,
    filterParams,
    setFilterParams,
    resetFilters,
  };
};

export default useSmartFetchHook;