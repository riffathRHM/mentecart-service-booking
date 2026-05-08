export const getParamId = (
  id: string | string[] | undefined
): string | null => {
  if (!id) return null;
  return Array.isArray(id) ? id[0] : id;
};