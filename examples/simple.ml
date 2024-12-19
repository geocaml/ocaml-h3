let printf = Printf.printf

let d2r = H3.degs_to_rads

let () =
    let austin_lat_rad = (H3.degs_to_rads 30.2672)  in
    let austin_lon_rad = (H3.degs_to_rads (-97.7431)) in
    printf "austin_lon_rad: %f\n" austin_lon_rad;
    let austin = H3.lat_lng_to_cell austin_lat_rad austin_lon_rad 12 in
    printf "Austin: %Lx\n" austin;
    let testo = H3.lat_lng_to_cell (d2r 40.689167) (d2r (-74.044444)) 5 in
    printf "Testo: %Lx\n" testo;
    let austin_geo_out = H3.cell_to_lat_lng austin in
    printf "Austin Out Lat: %f Lon: %f\n" austin_geo_out.lat austin_geo_out.lon;
    printf "Austin Out Lat: %f Lon: %f\n" (H3.rads_to_degs austin_geo_out.lat) (H3.rads_to_degs austin_geo_out.lon);
    let verts = H3.cell_to_boundary austin in
    printf "Austin GB num_verts: %d\n" (Array.length verts);
    Array.iter (fun (v : H3.lat_lng) -> printf "%f %f\n" v.lat v.lon) verts;
    printf "maxKringSize: %Ld\n" (H3.max_grid_disk_size 3);
    Array.iter (fun x -> printf "%Lx\n" x) (H3.grid_disk austin 5);
    printf "---\n%!";
    let (_neigh, dists) = (H3.grid_disk_distances austin 5) in
    Array.iter (fun x -> printf "dist=%d\n" x) dists;
    ()
