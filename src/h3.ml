
type h3_index = int64

type lat_lng = {
    lat: float;
    lon: float
}

type geo_fence = {
    num_verts : int;
    verts : lat_lng array
}

type geo_polygon = {
    fence : geo_fence;
    num_holes : int;
    holes : geo_fence
}

external degs_to_rads : float -> float = "caml_degsToRads"
external rads_to_degs : float -> float = "caml_radsToDegs"
external is_valid_cell : h3_index -> int = "caml_isValidCell"
external lat_lng_to_cell : float -> float -> int -> h3_index = "caml_latLngToCell"
external cell_to_lat_lng : h3_index -> float * float = "caml_cellToLatLng"
external cell_to_boundary : h3_index -> lat_lng array = "caml_cellToBoundary"
external max_grid_disk_size : int -> int64 = "caml_maxGridDiskSize"
external grid_disk : h3_index -> int -> h3_index array = "caml_gridDisk"
external grid_disk_distances : h3_index -> int -> h3_index array * int array = "caml_gridDiskDistances"
external get_resolution : h3_index -> int = "caml_getResolution"
external get_base_cell_number : h3_index -> int = "caml_getBaseCellNumber"
external string_to_h3 : string -> h3_index = "caml_stringToH3"
external get_hexagon_area_avg_km2 : int -> float = "caml_getHexagonAreaAvgKm2"
external cell_area_km2 : h3_index -> float = "caml_cellAreaKm2"
external are_neighbor_cells : h3_index -> h3_index -> int = "caml_areNeighborCells"

let geo_coord_to_cell gc =
    lat_lng_to_cell (degs_to_rads gc.lat) (degs_to_rads gc.lon)
