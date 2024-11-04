#define CAML_NAME_SPACE

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <h3/h3api.h>

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

CAMLprim value caml_degsToRads(value caml_degrees) {
    return caml_copy_double(degsToRads(Double_val(caml_degrees)));
}

CAMLprim value caml_radsToDegs(value caml_radians) {
    return caml_copy_double(radsToDegs(Double_val(caml_radians)));
}

CAMLprim value caml_getHexagonAreaAvgKm2(value caml_res) {
    // TODO: return err
    double out;
    H3Error err = getHexagonAreaAvgKm2(Int_val(caml_res), &out);
    return caml_copy_double(out);
}

CAMLprim value caml_cellAreaKm2(value caml_h3) {
    // TODO: return err
    double out;
    H3Error err = cellAreaKm2(Int64_val(caml_h3), &out);
    return caml_copy_double(out);
}

CAMLprim value caml_isValidCell(value caml_h3) {
    return Val_int(isValidCell(Int64_val(caml_h3)));
}

CAMLprim value caml_latLngToCell(value caml_lat, value caml_lon, value caml_res) {
    // TODO: return err
    H3Index out;
    LatLng geo_coord = {.lat = Double_val(caml_lat),
                          .lng = Double_val(caml_lon)};
    H3Error err = latLngToCell(&geo_coord, Int_val(caml_res), &out);
    return caml_copy_int64(out);
}

CAMLprim value caml_cellToLatLng(value caml_h3) {
    // TODO: return err
    CAMLparam1(caml_h3);
    CAMLlocal1(ret);
    LatLng geo_coord = {.lat = 0.0, .lng = 0.0};
    H3Error err = cellToLatLng(Int64_val(caml_h3), &geo_coord);
    ret = caml_alloc_tuple(2);
    Field(ret, 0) = caml_copy_double(geo_coord.lat);
    Field(ret, 1) = caml_copy_double(geo_coord.lng);
    CAMLreturn(ret);
}

CAMLprim value conv(char const *arrayval) {
    CAMLparam0 ();
    CAMLlocal1(ret);
    LatLng *coord = (LatLng*)arrayval;
    ret = caml_alloc_tuple(2);
    Store_double_field(ret, 0, coord->lat);
    Store_double_field(ret, 1, coord->lng);
    CAMLreturn(ret);
}

CAMLprim value caml_cellToBoundary(value caml_h3) {
    // TODO: return err
    CAMLparam1(caml_h3);
    CAMLlocal2(ret, arr);
    CellBoundary gb;
    H3Error err = cellToBoundary(Int64_val(caml_h3), &gb);
    ret = caml_alloc_tuple(2);

    LatLng* pro[MAX_CELL_BNDRY_VERTS];

    if (err == E_SUCCESS) {
        for (int i = 0; i < gb.numVerts; i++) {
            pro[i] = &(gb.verts[i]);
        }
        for (int i = gb.numVerts; i < MAX_CELL_BNDRY_VERTS; i++) {
            pro[i] = NULL;
        }
    } else {
        for (int i = 0; i < MAX_CELL_BNDRY_VERTS; i++) {
            pro[i] = NULL;
        }
    }
    arr = caml_alloc_array(conv, (const char **)(&pro));

    Field(ret, 0) = err == E_SUCCESS ? Val_int(gb.numVerts) : 0;
    Field(ret, 1) = arr;
    CAMLreturn(ret);
}

CAMLprim value caml_maxGridDiskSize(value caml_k) {
    // TODO: return err
    int64_t out;
    H3Error err = maxGridDiskSize(Int_val(caml_k), &out);
    return caml_copy_int64(out);
}

CAMLprim value caml_gridDisk(value caml_h3, value caml_k) {
    // TODO: return err
    CAMLparam2(caml_h3, caml_k);
    CAMLlocal1(ret);
    int k = Int_val(caml_k);

    int64_t count;
    H3Error err = maxGridDiskSize(k, &count);

    H3Index* rings = (H3Index*)calloc(count, sizeof(H3Index));
    err = gridDisk(Int64_val(caml_h3), k, rings);
    ret = caml_alloc_tuple(count);
    for (int i = 0; i < count; i++) {
        Store_field(ret, i, caml_copy_int64(rings[i]));
    }
    free(rings);
    CAMLreturn(ret);
}

CAMLprim value caml_gridDiskDistances(value caml_h3, value caml_k) {
    // TODO: return err
    CAMLparam2(caml_h3, caml_k);
    CAMLlocal3(ret, neigh, dists);
    int k = Int_val(caml_k);

    int64_t count;
    H3Error err = maxGridDiskSize(k, &count);

    H3Index* rings = (H3Index*)calloc(count, sizeof(H3Index));
    int* distances = (int*)calloc(count, sizeof(int));
    err = gridDiskDistances(Int64_val(caml_h3), k, rings, distances);
    ret = caml_alloc_tuple(2);
    neigh = caml_alloc_tuple(count);
    dists = caml_alloc_tuple(count);
    ret = caml_alloc(k, Abstract_tag);
    for (int i = 0; i < count; i++) {
        Field(neigh, i) = caml_copy_int64(rings[i]);
        Field(dists, i) = distances[i];
    }
    Field(ret, 0) = neigh;
    Field(ret, 1) = dists;
    free(rings);
    free(distances);
    CAMLreturn(ret);
}

CAMLprim value caml_getResolution(value v_h) {
    return Val_int(getResolution(Int64_val(v_h)));
}

CAMLprim value caml_getBaseCellNumber(value v_h) {
    return Val_int(getBaseCellNumber(Int64_val(v_h)));
}

CAMLprim value caml_stringToH3(value v_str) {
    // TODO: return err
    H3Index idx;
    H3Error err = stringToH3(String_val(v_str), &idx);
    return caml_copy_int64(idx);
}

CAMLprim value caml_areNeighborCells(value v_origin, value v_destination) {
    // TODO: return err
    int res;
    H3Error err = areNeighborCells(Int64_val(v_origin), Int64_val(v_destination), &res);
    return Val_int(res);
}
