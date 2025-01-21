let printf = Printf.printf
let mean_earth_radius = 6371.0088

let haversine_distance th1 ph1 th2 ph2 =
  let ph1 = ph1 -. ph2 in
  let dz = sin th1 -. sin th2 in
  let dx = (cos ph1 *. cos th1) -. cos th2 in
  let dy = sin ph1 *. cos th1 in
  asin (sqrt ((dx *. dx) +. (dy *. dy) +. (dz *. dz)))
  /. 2.0 *. 2.0 *. mean_earth_radius

let () =
  let uber_h3HQ1 = H3.string_to_h3 "8f2830828052d25" in
  let uber_h3HQ2 = H3.string_to_h3 "8f283082a30e623" in

  let hq1 = H3.cell_to_lat_lng uber_h3HQ1 in
  let hq2 = H3.cell_to_lat_lng uber_h3HQ2 in

  printf "origin: (%f, %f)\n" (H3.rads_to_degs hq1.lat)
    (H3.rads_to_degs hq1.lng);
  printf "destination: (%f, %f)\n" (H3.rads_to_degs hq2.lat)
    (H3.rads_to_degs hq2.lng);
  printf "distance: %fkm\n" (haversine_distance hq1.lat hq1.lng hq2.lat hq2.lng)

(*
 * C output `./distance`
origin: (37.775236, 237.580245)
destination: (37.789991, 237.597879)
distance: 2.256853km
 *)
