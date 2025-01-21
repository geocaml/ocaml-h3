type h3_index = int64
(** Identifier for an object (cell, edge, etc) in the H3 system. *)

type lat_lng = { lat : float; lng : float }
(** Type to store latitude/longitude in radians *)

external degs_to_rads : float -> float = "caml_degsToRads"
(** converts degrees to radians *)

external rads_to_degs : float -> float = "caml_radsToDegs"
(** converts radians to degrees *)

external is_valid_cell : h3_index -> int = "caml_isValidCell"
(** confirms if an h3_index is a valid cell (hexagon or pentagon) *)

external lat_lng_to_cell : lat_lng -> int -> h3_index = "caml_latLngToCell"
(** find the H3 index of the resolution res cell containing the lat/lng *)

external cell_to_lat_lng : h3_index -> lat_lng = "caml_cellToLatLng"
(** find the lat/lng center point of the H3 cell *)

external cell_to_boundary : h3_index -> lat_lng array = "caml_cellToBoundary"
(** give the cell boundary in lat/lng coordinates for the h3 cell *)

external max_grid_disk_size : int -> int64 = "caml_maxGridDiskSize"
(** maximum number of hexagons in k-ring *)

external grid_disk : h3_index -> int -> h3_index array = "caml_gridDisk"
(** hexagon neighbors in all directions *)

external grid_disk_distances : h3_index -> int -> h3_index array * int array
  = "caml_gridDiskDistances"
(** hexagon neighbors in all directions, reporting distance from origin *)

external get_resolution : h3_index -> int = "caml_getResolution"
(** returns the resolution of the provided H3 index *)

external get_base_cell_number : h3_index -> int = "caml_getBaseCellNumber"
(** returns the base cell "number" (0 to 121) of the provided H3 cell *)

external string_to_h3 : string -> h3_index = "caml_stringToH3"
(** converts the canonical string format to H3Index format *)

external get_hexagon_area_avg_km2 : int -> float = "caml_getHexagonAreaAvgKm2"
(** average hexagon area in square kilometers (excludes pentagons) *)

external cell_area_km2 : h3_index -> float = "caml_cellAreaKm2"
(** exact area for a specific cell (hexagon or pentagon) in kilometers^2 *)

external are_neighbor_cells : h3_index -> h3_index -> int
  = "caml_areNeighborCells"
(** returns whether or not the provided hexagons border *)

(** converts a lat/lng pair from degrees to radians *)
let geo_coord_to_cell gc =
  lat_lng_to_cell { lat = degs_to_rads gc.lat; lng = degs_to_rads gc.lng }
