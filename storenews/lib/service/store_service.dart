// TODO caching as stores dont change often

String storeEndpoint(int companyId, int storeId) =>
    "/store/$companyId/$storeId";