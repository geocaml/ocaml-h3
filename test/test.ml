let sprintf = Printf.sprintf

let test_degs_to_rads () =
    Alcotest.(check (float 0.0001)) "Check degs_to_rads" 0.0174533 (H3.degs_to_rads 1.0)

let test_rads_to_degs () =
    Alcotest.(check (float 0.0001)) "Check rads_to_degs" 57.2958 (H3.rads_to_degs 1.0)

let test_is_valid_cell () =
    let h3 = H3.string_to_h3 "845ad1bffffffff" in
    Alcotest.(check int) "check is_valid" 1 (H3.is_valid_cell h3)

let test_d2r_r2d_roundtrip () =
    let result = H3.degs_to_rads 40.7128 |> H3.rads_to_degs in
    Alcotest.(check (float 0.0001)) "check d2r_r2d roundtrip" 40.7128 result

let test_r2d_d2r_roundtrip () =
    let result = (H3.rads_to_degs 0.7105724077 |> H3.degs_to_rads) in
    Alcotest.(check (float 0.0001)) "Check test_r2d_d2r_roundtrip" 0.7105724077 result

let test_max_grid_disk_size () =
    Alcotest.(check bool) "check max_kring_size" true ((H3.max_grid_disk_size 3) > 0L)

(* From the Examples: https://uber.github.io/h3/#/documentation/core-library/unix-style-filters
echo 40.689167 -74.044444 | geoToH3 5
852a1073fffffff
*)
let test_lat_lng_to_cell () =
    let _result = H3.lat_lng_to_cell (H3.degs_to_rads 40.689167) (H3.degs_to_rads (-74.044444)) 5 in
    let result = sprintf "%Lx" _result in
     Alcotest.(check string) "Check string H3" "852a1073fffffff" result
(*
echo 845ad1bffffffff | h3ToGeo
22.3204847179 169.7200239903
*)
let test_cell_to_lat_lng () =
    (*
    ((lat -. 22.3204847179) < 0.0001) && ((lon -. 169.7200239903) < 0.0001)
    *)
    let x = Scanf.sscanf "845ad1bffffffff" "%Lx" (fun s -> s) in
    let loc = H3.cell_to_lat_lng x in
    let lat, lon = H3.rads_to_degs loc.lat, H3.rads_to_degs loc.lon in
    Alcotest.(check (float 0.0001)) "check h3_to_geo lat" 22.3204847179 lat;
    Alcotest.(check (float 0.0001)) "check h3_to_geo lon" 169.7200239903 lon

let test_hex_area_km2_decreasing () =
    let h3_resolutions = [15; 14; 13; 12; 11; 10; 9; 8; 7; 6; 5; 4; 3; 2; 1] in
    let _results = List.map (fun i -> (H3.get_hexagon_area_avg_km2 i) < (H3.get_hexagon_area_avg_km2 (i-1))) h3_resolutions in
    let result = List.fold_left (fun acc x -> acc = x) true _results in
    Alcotest.(check bool) "Check test hex area decreasing" true result

let test_self_not_a_neighbor () =
    let sf_h3 = H3.lat_lng_to_cell 0.659966917655 (-2.1364398519396) 9 in
    let result = H3.are_neighbor_cells sf_h3 sf_h3 in
    Alcotest.(check int) "Check self not a neighbor" 0 result


(*
 * In C lib
 * bin/geoToH3 9                                                                                                                Thu Apr  5 19:51:58 2018
48.8566 2.3522
891fb466257ffff
*)
let test_h3_of_geo_coord () =
    let paris = {H3.lat=48.8566; H3.lon=2.3522} in
    let paris_h3 = H3.geo_coord_to_cell paris 9 in
    let paris_h3_str = sprintf "%Lx" paris_h3 in
    Alcotest.(check string) "Check paris H3" "891fb466257ffff" paris_h3_str



let test_set = [
    "test_degs_to_rads", `Slow, test_degs_to_rads;
    "test_rads_to_degs", `Slow, test_rads_to_degs;
    "test_is_valid_cell", `Slow, test_is_valid_cell;
    "test_d2r_r2d_roundtrip", `Slow, test_d2r_r2d_roundtrip;
    "test_r2d_d2r_roundtrip", `Slow, test_r2d_d2r_roundtrip;
    "test_max_grid_disk_size", `Slow, test_max_grid_disk_size;
    "test_lat_lng_to_cell", `Slow, test_lat_lng_to_cell;
    "test_cell_to_lat_lng", `Slow, test_cell_to_lat_lng;
    "test_hex_area_km2_decreasing", `Slow, test_hex_area_km2_decreasing;
    "test_self_not_a_neighbor", `Slow, test_self_not_a_neighbor;
    "test_h3_of_geo_coord", `Slow, test_h3_of_geo_coord;
]

let () =
    Alcotest.run "Run Tests" [
        "test_1", test_set;
    ]
